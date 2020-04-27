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
    
    private let sectionUrls: [MWSection] = [
        MWSection(name: "Now Playing", url: MWURLPaths.nowPlayingMovies),
        MWSection(name: "Popular Movies", url: MWURLPaths.popularMovies),
        MWSection(name: "Top Rated Movies", url: MWURLPaths.topRatedMovies),
        MWSection(name: "Upcoming Movies", url: MWURLPaths.upcomingMovies)]
    
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
        
        self.setSectionsAndReload()
        
        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.sections.removeAll()
            self.setSectionsAndReload()
        }
    }
    
    // MARK: - Request methods
    
    private func initRequest() {
        self.sectionUrls.forEach { self.request(section: $0) }
    }
    
    private func request(section: MWSection) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            successHandler: { [weak self] (results: MWMovieResults) in
                let movies = results.results
                MWCoreDataManager.sh.saveSection(section: section, movies: movies)
                self?.loadImages(movies: movies)
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self] error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }
    
    private func loadImages(movies: [MWMovie]) {
        for movie in movies {
            MWNet.sh.downloadImage(
                movie.posterPath,
                handler: { [weak self] image in
                    MWCoreDataManager.sh.saveMovieImage(image: image, for: movie)
                    self?.tableView.reloadData()
            })
        }
    }
    
    // MARK: - RefreshControl action
    
    @objc func refresh(refreshControl: UIRefreshControl) {        
        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            refreshControl.endRefreshing()
            self.sections.removeAll()
            self.setSectionsAndReload()
        }
    }
    
    // MARK: - Sections set method
    
    private func setSectionsAndReload() {
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
