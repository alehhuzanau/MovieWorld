//
//  MWMainMoviesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainMoviesViewController: UIViewController {
    
    // MARK: - Variables
    
    private let minimumSpacing: CGFloat = 8
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var movies: [Movie] = []
    
    // MARK: - GUI variables
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MWGenreCollectionViewCell.self,
            forCellWithReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier)
        
        return collectionView
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
        
        return tableView
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies".localized
        
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
            let cellHeight = self.sizeForCollectionViewCell().height
            let heigth = self.collectionViewInsets.top + cellHeight + self.minimumSpacing
                + cellHeight + self.collectionViewInsets.bottom
            make.height.equalTo(heigth)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Flow layout
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = self.minimumSpacing
        layout.minimumLineSpacing = self.minimumSpacing
        layout.sectionInset = self.collectionViewInsets
        
        return layout
    }
}

extension MWMainMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWGenreCollectionViewCell ?? MWGenreCollectionViewCell()
        cell.set(movie: self.movies[indexPath.item])
        
        return cell
    }
}

extension MWMainMoviesViewController: UICollectionViewDelegateFlowLayout {
    private func sizeForCollectionViewCell(labelText: String? = "Text") -> CGSize {
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
        let heigth = insets.top + label.frame.height + insets.bottom
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeForCollectionViewCell(labelText: self.movies[indexPath.item].title)
    }
}

extension MWMainMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieCardTableViewCell.reuseIdentifier)
            as? MWMovieCardTableViewCell ?? MWMovieCardTableViewCell()
        cell.set(movie: self.movies[indexPath.row])
        
        return cell
    }
}
