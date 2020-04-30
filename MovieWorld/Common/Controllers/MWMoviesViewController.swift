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

    private var isFiltered: Bool = false

    private var isLoading: Bool = false

    private var totalPages: Int?

    private var currentPage: Int = 1

    private var movies: [Movie] = [] {
        didSet {
            self.filteredMovies = self.movies
        }
    }

    private var filteredMovies: [Movie] = []

    private lazy var genres: [Genre] = {
        return MWCoreDataManager.sh.fetchGenres() ?? []
    }()

    private lazy var collectionViewHeight: CGFloat = {
        guard self.genres.count != 0 else { return 0 }
        let cellHeight = self.sizeForCollectionViewCell().height
        let insetsHeight = self.collectionViewInsets.top + self.collectionViewInsets.bottom
        let rows = CGFloat(self.numberOfRows)

        return cellHeight * rows + self.cellPadding * (rows - 1) + insetsHeight
    }()

    var numberOfRows: Int = 2
    var cellPadding: CGFloat = 8

    var section: Section? {
        didSet {
            if let movies = self.section?.getMovies(), movies.count != 0 {
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

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = MWLeftAlignedViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.delegate = self

        return layout
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isUserInteractionEnabled = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = self.refreshControl

        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: Constants.ColorName.accentColor)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    private lazy var bottomSpinner: UIActivityIndicatorView = {
        var style: UIActivityIndicatorView.Style = .gray
        if #available(iOS 13.0, *) {
            style = .large
        }
        let indicator = UIActivityIndicatorView(style: style)
        indicator.frame.size.height = indicator.frame.height + self.spinnerInsets.top
            + self.spinnerInsets.bottom
        indicator.color = UIColor(named: Constants.ColorName.accentColor)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()

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
            if filteredGenres.allSatisfy(movie.getGenres().contains) {
                self.filteredMovies.append(movie)
            }
        }
        self.isFiltered = true
        self.tableView.reloadData()
    }

    // MARK: - RefreshControl action

    @objc func refresh(refreshControl: UIRefreshControl) {
        guard !self.isFiltered, !self.isLoading else {
            refreshControl.endRefreshing()
            return
        }
        self.request(isFirstPage: true)
        self.dispatchGroup.notify(queue: .main) {
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    // MARK: - Request methods

    private func request(isFirstPage: Bool = false) {
        guard let section = self.section, let url = section.urlPath else { return }
        if isFirstPage {
            self.movies.removeAll()
            self.tableView.reloadData()
            self.currentPage = 1
        } else {
            self.currentPage += 1
        }
        var parameters = ["page": String(self.currentPage)]
        parameters.merge(other: section.getParameters())
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: url,
            parameters: parameters,
            successHandler: { [weak self] (results: MWMovieResults) in
                self?.totalPages = results.totalPages
                let dispatchGroup = DispatchGroup()
                self?.saveToMovies(movies: results.results, dispatchGroup: dispatchGroup)
                dispatchGroup.notify(queue: .main) {
                    self?.dispatchGroup.leave()
                }
            },
            errorHandler: { [weak self] error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }

    private func saveToMovies(movies: [MWMovie], dispatchGroup: DispatchGroup) {
        for movie in movies {
            dispatchGroup.enter()
            MWNet.sh.downloadImage(
                movie.posterPath,
                handler: { image in
                    let newMovie = Movie.getMovie(from: movie)
                    newMovie.image = image
                    self.movies.append(newMovie)
                    dispatchGroup.leave()
            })
        }
    }
}

extension MWMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWGenreCollectionViewCell ?? MWGenreCollectionViewCell()
        cell.set(genre: self.genres[indexPath.item])

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

extension MWMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieCardTableViewCell.reuseIdentifier)
            as? MWMovieCardTableViewCell ?? MWMovieCardTableViewCell()
        cell.set(movie: self.filteredMovies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let totalPages = self.totalPages, self.currentPage == totalPages { return }
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex, !self.isFiltered, !self.isLoading {
            self.isLoading = true
            self.tableView.tableFooterView = self.bottomSpinner
            self.request()
            self.dispatchGroup.notify(queue: .main) {
                self.isLoading = false
                self.tableView.tableFooterView = nil
                self.tableView.reloadData()
            }
        }
    }
}
