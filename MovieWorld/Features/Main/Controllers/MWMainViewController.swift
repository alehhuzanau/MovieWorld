//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainViewController: UITableViewController {
    
    // MARK: - Variables
        
    private let sectionUrls: [MWSectionUrl] = [
        MWSectionUrl(name: "Now Playing", url: MWURLPaths.nowPlayingMovies),
        MWSectionUrl(name: "Popular Movies", url: MWURLPaths.popularMovies),
        MWSectionUrl(name: "Top Rated Movies", url: MWURLPaths.topRatedMovies),
        MWSectionUrl(name: "Upcoming Movies", url: MWURLPaths.upcomingMovies)]
    
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
        self.tableView.separatorStyle = .none
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
    
    private func request(section: MWSectionUrl) {
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
                    MWCoreDataManager.sh.saveMovie(from: movie, imageData: image)
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
        guard let sections = MWCoreDataManager.sh.fetchSections() else { return }
        for sectionUrl in self.sectionUrls {
            if let section = sections.first(where: { $0.name == sectionUrl.name }) {
                self.sections.append(section)
                self.tableView.reloadData()
            }
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
            let vc = MWMoviesViewController()
            vc.section = self.sections[indexPath.row]
            MWI.sh.push(vc: vc)
        }
        
        return cell
    }
}
