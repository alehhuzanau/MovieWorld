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
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
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
        self.tableView.refreshControl?.tintColor = .accent
        self.tableView.refreshControl?.addTarget(
            self, action: #selector(self.refresh), for: .valueChanged)
    }

    // MARK: - Request methods

    private func initRequest() {
        self.sections.forEach {
            self.request(section: $0)
        }
    }

    private func request(section: MWSection) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            successHandler: { [weak self] (results: MWMovieResults) in
                let movies = results.movies
                section.movies = movies
                MWCoreDataManager.sh.saveSection(section: section)
                self?.loadImages(movies: movies)
                self?.loadDetails(movies: movies)
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self] error in
                print(error.getDescription())
                self?.setMoviesFromCoreData(section: section)
                self?.dispatchGroup.leave()
        })
    }

    private func loadImages(movies: [MWMovie]) {
        for movie in movies {
            MWNet.sh.downloadImage(
                movie.posterPath,
                completionHandler: { [weak self] data in
                    MWCoreDataManager.sh.saveMovieImage(image: data, for: movie)
                    movie.imageData = data
                    self?.tableView.reloadData()
            })
        }
    }

    private func loadDetails(movies: [MWMovie]) {
        for movie in movies {
            let url = "\(MWURLPaths.movieDetails)\(movie.id)"
            MWNet.sh.request(
                urlPath: url,
                successHandler: { (detail: MWMovieDetail) in
                    movie.countries = detail.countries
                },
                errorHandler: { error in
                    print(error.getDescription())
            })
        }
    }

    private func setMoviesFromCoreData(section: MWSection) {
        guard let coreSections = MWCoreDataManager.sh.fetchSections(),
            let coreSection = coreSections.first(where: { $0.name == section.name }) else { return }
        section.movies = coreSection.getMovies().map { $0.getMovie() }
    }

    // MARK: - RefreshControl action

    @objc private func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()

        self.initRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

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
            cell.allButtonTapped = { [weak self] in
                let vc = MWMoviesViewController()
                vc.section = self?.sections[indexPath.row]
                MWI.sh.push(vc: vc)
            }
        }

        return cell
    }
}
