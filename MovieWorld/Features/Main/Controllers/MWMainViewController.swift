//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

typealias SectionUrl = (name: String, url: String)

class MWMainViewController: UITableViewController {
    
    // MARK: - Variables
        
    private let sectionUrls: [SectionUrl] = [
        (name: "Now Playing", url: MWURLPaths.nowPlayingMovies),
        (name: "Popular Movies", url: MWURLPaths.popularMovies),
        (name: "Top Rated Movies", url: MWURLPaths.topRatedMovies),
        (name: "Upcoming Movies", url: MWURLPaths.upcomingMovies)]
    
    private let dispatchGroup = DispatchGroup()
    
    private var sections: [Section] = []
    
    // MARK: - GUI variables
    
    private lazy var _refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: Constants.ColorName.accentColor)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Season".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isUserInteractionEnabled = true
        self.tableView.rowHeight = 305
        self.tableView.refreshControl = self._refreshControl
        
        self.setSections()
        
        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.sections.removeAll()
            self.setSections()
        }
    }
    
    // MARK: - Request methods
    
    private func initRequest() {
        self.sectionUrls.forEach { self.request(section: $0) }
    }
    
    private func request(section: SectionUrl) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            successHandler: { [weak self] (results: MWMovieResults) in
                MWCoreDataManager.sh.deleteSection(name: section.name)
                let movies = results.results
                let dispatchGroup = DispatchGroup()
                self?.saveMoviesToCoreData(movies: movies, dispatchGroup: dispatchGroup)
                dispatchGroup.notify(queue: .main) {
                    MWCoreDataManager.sh.saveSection(name: section.name, urlPath: section.url, movies: movies)
                    self?.dispatchGroup.leave()
                }
            },
            errorHandler: { [weak self] error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }
    
    private func saveMoviesToCoreData(movies: [MWMovie], dispatchGroup: DispatchGroup) {
        for movie in movies {
            dispatchGroup.enter()
            MWNet.sh.downloadImage(
                movie.posterPath,
                successHandler: { image in
                    MWCoreDataManager.sh.saveMovie(
                        id: movie.id,
                        title: movie.title,
                        releaseDate: movie.releaseDate,
                        posterPath: movie.posterPath,
                        image: image,
                        genreIds: movie.genres)
                    dispatchGroup.leave()
            })
        }
    }
    
    // MARK: - RefreshControl action
    
    @objc func refresh(refreshControl: UIRefreshControl) {        
        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.sections.removeAll()
            self.setSections()
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Sections set method

    private func setSections() {
        for section in MWCoreDataManager.sh.fetchSections() ?? [] {
            self.sections.append(section)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier)
            as? MWMovieSectionTableViewCell ?? MWMovieSectionTableViewCell()
        cell.set(section: self.sections[indexPath.row])
        cell.pushVC = {
            let vc = MWMainMoviesViewController()
            vc.movies = self.sections[indexPath.row].getMovies()
            vc.movies = self.sections[indexPath.row].getMovies()
            MWI.sh.push(vc: vc)
        }
        
        return cell
    }
}
