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
    
    private let dispatchGroup = DispatchGroup()
    
    private var sections: [Section] = []
    
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: Constants.ColorName.accentColor)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        self.setSections()
        
        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.sections.removeAll()
            self.setSections()
        }
    }
    
    // MARK: - Request methods
    
    private func initRequest() {
        self.request(sectionName: "Now Playing", urlPath: MWURLPaths.nowPlayingMovies)
        self.request(sectionName: "Popular Movies", urlPath: MWURLPaths.popularMovies)
        self.request(sectionName: "Top Rated Movies", urlPath: MWURLPaths.topRatedMovies)
        self.request(sectionName: "Upcoming Movies", urlPath: MWURLPaths.upcomingMovies)
    }
    
    private func request(sectionName: String, urlPath: String) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: urlPath,
            successHandler: { [weak self] (results: MWMovieResults) in
                MWCoreDataManager.sh.deleteSection(name: sectionName)
                let movies = results.results
                let dispatchGroup = DispatchGroup()
                self?.saveMoviesToCoreData(movies: movies, dispatchGroup: dispatchGroup)
                dispatchGroup.notify(queue: .main) {
                    MWCoreDataManager.sh.saveSection(name: sectionName, movies: movies)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier)
            as? MWMovieSectionTableViewCell ?? MWMovieSectionTableViewCell()
        cell.selectionStyle = .none
        cell.set(section: self.sections[indexPath.row])
        cell.pushVC = {
            let vc = MWMainMoviesViewController()
            vc.movies = self.sections[indexPath.row].getMovies()
            MWI.sh.push(vc: vc)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
