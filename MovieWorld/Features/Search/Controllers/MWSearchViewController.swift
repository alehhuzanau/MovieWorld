//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWSearchViewController: UITableViewController {

    // MARK: - Variables

    private var movies: [MWMovie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Search".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTableView()
        self.setSearchController()
        self.request()
    }

    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(
            MWMovieCardTableViewCell.self,
            forCellReuseIdentifier: MWMovieCardTableViewCell.reuseIdentifier)
    }

    private func setSearchController() {
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func request() {
        MWNet.sh.request(
            urlPath: MWURLPaths.nowPlayingMovies,
            successHandler: { [weak self] (results: MWMovieResults) in
                let movies = results.results
                self?.movies = movies
            },
            errorHandler: { error in
                print(error.getDescription())
        })
    }

    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieCardTableViewCell.reuseIdentifier,
            for: indexPath)
        (cell as? MWMovieCardTableViewCell)?.set(movie: self.movies[indexPath.row])

        return cell
    }
}
