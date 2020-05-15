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

    private let edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

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

    // MARK: - GUI variables

    private lazy var requestLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a request or\nconfigure a filter"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.alpha = 0.5
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor(named: Constants.ColorName.accentColor)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.clearButtonMode = .never
        } else {
            searchController.searchBar.textField.clearButtonMode = .never
        }

        return searchController
    }()

    private lazy var filterButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: UIImage(named: Constants.ImageName.filterIcon),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped))
    }()

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Search".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTableView()
        self.setNavigationItem()
        self.addSubviews()
        self.makeConstraints()
    }

    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(
            MWMovieCardTableViewCell.self,
            forCellReuseIdentifier: MWMovieCardTableViewCell.reuseIdentifier)
    }

    private func setNavigationItem() {
        self.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = self.filterButton
    }

    private func addSubviews() {
        self.view.addSubview(self.requestLabel)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.requestLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(self.edgeInsets)
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Request methods

    private func request() {
        MWNet.sh.request(
            urlPath: self.section.url,
            parameters: self.section.parameters,
            successHandler: { [weak self] (results: MWMovieResults) in
                let movies = results.results
                self?.movies = movies
                self?.loadImages(movies: movies)
            },
            errorHandler: { error in
                print(error.getDescription())
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

    // MARK: - filterButton tap action

    @objc func filterButtonTapped(_ button: UIBarButtonItem) {
        MWI.sh.push(vc: MWFilterViewController())
    }
}

extension MWSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !self.isSearchBarEmpty {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.sizeToFit()
            self.requestLabel.isHidden = true
            let searchBar = self.navigationItem.searchController?.searchBar
            self.section.parameters["query"] = searchBar?.text
            self.request()
        } else {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.sizeToFit()
            self.requestLabel.isHidden = false
            self.movies = []
        }
    }
}
