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

    private let baseSections: [MWSectionsEnum] = [
        .nowPlaying,
        .popularMovies,
        .topRatedMovies,
        .upcomingMovies]

    private let dispatchGroup = DispatchGroup()

    private lazy var sections: [MWSection] = {
        var sections: [MWSection] = []
        self.baseSections.forEach {
            sections.append($0.getSection())
        }

        return sections
    }()

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Season".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTableView()
        self.initRequest()
    }

    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 305
        self.tableView.register(
            MWMovieSectionTableViewCell.self,
            forCellReuseIdentifier: MWMovieSectionTableViewCell.reuseIdentifier)

        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.tintColor = UIColor(named: Constants.ColorName.accentColor)
        self.tableView.refreshControl?.addTarget(
            self, action: #selector(self.refresh), for: .valueChanged)
    }

    // MARK: - Request methods

    private func initRequest() {
        self.sections.forEach {
            self.request(section: $0)
        }
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    private func request(section: MWSection) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            successHandler: { [weak self] (results: MWMovieResults) in
                let movies = results.results
                section.movies = movies
                //MWCoreDataManager.sh.saveSection(section: section, movies: movies)
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
                handler: { [weak self] data in
                    //MWCoreDataManager.sh.saveMovieImage(image: image, for: movie)
                    movie.image = data
                    //self?.tableView.reloadData()
            })
        }
    }

    // MARK: - RefreshControl action

    @objc
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()

//        self.initRequest()
//        self.dispatchGroup.notify(queue: .main) {
//            refreshControl.endRefreshing()
//            self.setSectionsAndReload()
//        }
    }

    // MARK: - Sections set method

//    private func setSectionsAndReload() {
//        guard let sections = MWCoreDataManager.sh.fetchSections() else { return }
//        self.sections.removeAll()
//        for sectionUrl in self.sectionUrls {
//            if let section = sections.first(where: { $0.name == sectionUrl.getSection().name }) {
//                self.sections.append(section)
//                self.tableView.reloadData()
//            }
//        }
//    }

    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier,
            for: indexPath)
        if let cell = cell as? MWMovieSectionTableViewCell {
            cell.set(section: self.sections[indexPath.row])
//            cell.allButtonTapped = { [weak self] in
//                let vc = MWMoviesViewController()
//                vc.section = self?.sections[indexPath.row]
//                MWI.sh.push(vc: vc)
//            }
        }

        return cell
    }
}
