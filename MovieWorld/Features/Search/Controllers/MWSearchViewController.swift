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
    private let spinnerInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    private let requestRow: Int = 5

    private let dispatchGroup = DispatchGroup()

    private let searchSection: MWSection = MWSection(
        name: "Search",
        url: MWURLPaths.searchMovies,
        parameters: ["query": "",
                     "year": ""])

    private let filterSection: MWSection = MWSection(
        name: "Filter",
        url: MWURLPaths.discoverMovie,
        parameters: ["with_genres": "",
                     "primary_release_year": "",
                     "vote_average.gte": "",
                     "vote_average.lte": ""])

    private var pageParameters: [String: String] {
        ["page": String(self.currentPage)]
    }

    private var movies: [MWMovie] = []

    private var isSearchBarEmpty: Bool {
        return self.navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }

    private var isLoading: Bool = false

    private var totalPages: Int?
    private var currentPage: Int = 1

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
        searchController.searchBar.tintColor = .accent
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.textField.clearButtonMode = .never

        return searchController
    }()

    private lazy var filterButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: UIImage(named: Constants.ImageName.filterIcon),
            style: .plain,
            target: self,
            action: #selector(self.filterButtonTapped))
    }()

    private lazy var bottomSpinner: UIActivityIndicatorView = {
        var style: UIActivityIndicatorView.Style = .whiteLarge
        if #available(iOS 13.0, *) {
            style = .large
        }
        let indicator = UIActivityIndicatorView(style: style)
        indicator.frame.size.height = indicator.frame.height + self.spinnerInsets.top
            + self.spinnerInsets.bottom
        indicator.color = .accent

        return indicator
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

    private func request(section: MWSection) {
        var parameters = self.pageParameters
        parameters.merge(other: section.parameters)
        self.isLoading = true
        self.tableView.tableFooterView = self.bottomSpinner
        self.bottomSpinner.startAnimating()
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            parameters: parameters,
            successHandler: { [weak self] (results: MWMovieResults) in
                self?.totalPages = results.totalPages
                let movies = results.movies
                self?.movies.append(contentsOf: movies)
                self?.tableView.reloadData()
                self?.loadImages(movies: movies)
                self?.loadDetails(movies: movies)
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self] error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
        self.dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            self.tableView.tableFooterView = nil
        }
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
                successHandler: { [weak self] (detail: MWMovieDetail) in
                    movie.countries = detail.countries
                    self?.tableView.reloadData()
            },
                errorHandler: { error in
                    print(error.getDescription())
            })
        }
    }

    // MARK: - filterButton tap action

    @objc func filterButtonTapped(_ button: UIBarButtonItem) {
        let vc = MWFilterViewController()
        vc.filterSelected = { [weak self] (filter: MWFilter) in
            guard let self = self else { return }
            self.setFilterSectionParams(filter: filter)
            self.requestLabel.isHidden = true
            self.request(section: self.filterSection)
        }
        MWI.sh.push(vc: vc)
        self.searchController.isActive = false
    }

    private func setFilterSectionParams(filter: MWFilter) {
        if let genres = filter.genres {
            self.filterSection.parameters["with_genres"] =
                genres
                    .map { String($0.id) }
                    .joined(separator: ", ")
        }
        if let year = filter.year {
            self.filterSection.parameters["primary_release_year"] = String(year)
        }
        if let minVote = filter.minVote, let maxVote = filter.maxVote {
            self.filterSection.parameters["vote_average.gte"] = String(minVote)
            self.filterSection.parameters["vote_average.lte"] = String(maxVote)
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

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        if let totalPages = self.totalPages, self.currentPage >= totalPages { return }
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - self.requestRow
        if indexPath.row == lastRowIndex, !self.isLoading {
            self.currentPage += 1
            let section = self.isSearchBarEmpty ? self.filterSection : self.searchSection
            self.request(section: section)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MWMovieInfoViewController()
        vc.movie = self.movies[indexPath.row]
        MWI.sh.push(vc: vc)
    }
}

extension MWSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.currentPage = 1
        self.movies.removeAll()
        self.tableView.reloadData()
        if !self.isSearchBarEmpty, !self.isLoading {
            self.requestLabel.isHidden = true
            let searchBar = self.navigationItem.searchController?.searchBar
            self.searchSection.parameters["query"] = searchBar?.text
            self.request(section: self.searchSection)
        } else if self.isSearchBarEmpty {
            self.requestLabel.isHidden = false
        }
    }
}
