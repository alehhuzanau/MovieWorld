//
//  MWMoviesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMoviesViewController: UIViewController {

    // MARK: - Variables

    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let spinnerInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)

    private let dispatchGroup = DispatchGroup()

    private let requestRow: Int = 5

    private var isFiltered: Bool = false
    private var isLoading: Bool = false

    private var totalPages: Int?
    private var currentPage: Int = 1

    private var pageParameters: [String: String] {
        ["page": String(self.currentPage)]
    }

    private var movies: [MWMovie] = [] {
        didSet {
            self.filteredMovies = self.movies
        }
    }

    private var filteredMovies: [MWMovie] = []

    private lazy var genres: [MWGenre] = {
        return (MWSystem.sh.genres ?? [])
    }()

    var numberOfRows: Int = 2
    var cellPadding: CGFloat = 8

    var section: MWSection? {
        didSet {
            if let movies = self.section?.movies, movies.count != 0 {
                self.movies = movies
            } else {
                self.request(isFirstPage: true)
                self.dispatchGroup.notify(queue: .main) {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - GUI variables

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = self.collectionViewInsets
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            MWGenreCollectionViewCell.self,
            forCellWithReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier)

        return collectionView
    }()

    private lazy var flowLayout: MWLeftAlignedViewFlowLayout = {
        let layout = MWLeftAlignedViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.delegate = self

        return layout
    }()

    private lazy var collectionViewHeight: CGFloat = {
        guard self.genres.count != 0 else { return 0 }
        let cellHeight = self.sizeForCollectionViewCell().height
        let insetsHeight = self.collectionViewInsets.top + self.collectionViewInsets.bottom
        let rows = CGFloat(self.numberOfRows)

        return cellHeight * rows + self.cellPadding * (rows - 1) + insetsHeight
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = self.refreshControl
        tableView.register(
            MWMovieCardTableViewCell.self,
            forCellReuseIdentifier: MWMovieCardTableViewCell.reuseIdentifier)

        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .accent
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
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

        self.navigationItem.title = self.section?.name ?? "Movies".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.collectionViewHeight)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Data filtering method

    private func filterMovies() {
        guard let indexPaths = self.collectionView.indexPathsForSelectedItems,
            indexPaths.count != 0 else {
                self.filteredMovies = self.movies
                self.isFiltered = false
                self.tableView.reloadData()

                return
        }
        let filteredGenres = indexPaths.map { self.genres[$0.row] }

        self.filteredMovies = []
        for movie in self.movies {
            if filteredGenres.allSatisfy(movie.genres.contains) {
                self.filteredMovies.append(movie)
            }
        }
        self.isFiltered = true
        self.tableView.reloadData()
    }

    // MARK: - RefreshControl action

    @objc private func refresh(refreshControl: UIRefreshControl) {
        guard !self.isFiltered, !self.isLoading else {
            refreshControl.endRefreshing()
            return
        }
        self.request(isFirstPage: true)
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

    // MARK: - Request methods

    private func request(isFirstPage: Bool = false) {
        guard let section = self.section else { return }
        if isFirstPage {
            self.movies.removeAll()
            self.currentPage = 1
        } else {
            self.currentPage += 1
        }
        var parameters = self.pageParameters
        parameters.merge(other: section.parameters)
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: section.url,
            parameters: parameters,
            successHandler: { [weak self] (results: MWMovieResults) in
                self?.totalPages = results.totalPages
                let movies = results.results
                self?.movies.append(contentsOf: movies)
                self?.tableView.reloadData()
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
                completionHandler: { [weak self] data in
                    movie.imageData = data
                    self?.tableView.reloadData()
            })
        }
    }
}

// MARK: - genres collectionView methods

extension MWMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier,
            for: indexPath)
        (cell as? MWGenreCollectionViewCell)?.set(genre: self.genres[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.filterMovies()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.filterMovies()
    }
}

extension MWMoviesViewController: MWLeftAlignedDelegateViewFlowLayout {
    private func sizeForCollectionViewCell(labelText: String? = " ") -> CGSize {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude))
        label.font = label.font.withSize(13)
        label.text = labelText
        label.sizeToFit()

        let insets = MWGenreCollectionViewCell.viewInsets
        let width = insets.left + label.frame.width + insets.right
        let height = insets.top + label.frame.height + insets.bottom

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeForCollectionViewCell(labelText: self.genres[indexPath.item].name)
    }
}

// MARK: - movies tableView methods

extension MWMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieCardTableViewCell.reuseIdentifier,
            for: indexPath)
        (cell as? MWMovieCardTableViewCell)?.set(movie: self.filteredMovies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let totalPages = self.totalPages, self.currentPage == totalPages { return }
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - self.requestRow
        if indexPath.row == lastRowIndex, !self.isFiltered, !self.isLoading {
            self.isLoading = true
            self.tableView.tableFooterView = self.bottomSpinner
            self.bottomSpinner.startAnimating()
            self.request()
            self.dispatchGroup.notify(queue: .main) {
                self.isLoading = false
                self.tableView.tableFooterView = nil
                self.tableView.reloadData()
            }
        }
    }
}
