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

    private let section: MWSection = MWSection(
        name: "Search",
        url: MWURLPaths.searchMovies,
        parameters: ["query": "",
                     "year": ""])

    private var movies: [MWMovie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    private var isSearchBarEmpty: Bool {
        return self.navigationItem.searchController?.searchBar.text?.isEmpty ?? true
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
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.clearButtonMode = .never
        self.navigationItem.searchController = searchController
    }

    private func request() {
        MWNet.sh.request(
            urlPath: self.section.url,
            parameters: self.section.parameters,
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

extension MWSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !self.isSearchBarEmpty {
            let searchBar = self.navigationItem.searchController?.searchBar
            self.section.parameters["query"] = searchBar?.text
            self.request()
        } else {
            self.movies = []
        }
    }
}
