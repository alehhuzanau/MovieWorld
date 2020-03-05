//
//  MWMovieSectionTableViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWMovieSectionTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "MWMovieTableViewCell"
    
    // MARK: - Variables
    
    private var movies: [MWMovie] = []
    
    private let edgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 7)
    private let buttonSize = CGSize(width: 52, height: 24)
    
    // MARK: - SubViews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MWCardCollectionViewCell.self,
            forCellWithReuseIdentifier: MWCardCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private lazy var allButton: UIButton = MWNextButton(type: .system)
    
    // MARK: - Init methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.allButton)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
        }
        self.allButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(self.edgeInsets)
            make.size.equalTo(self.buttonSize)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Flow layout
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 130, height: 237)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
        
        return layout
    }
    
    // MARK: - Data set methods
    
    func set(section: MWSection) {
        self.titleLabel.text = section.name
        self.movies = section.movies
        
        self.setNeedsUpdateConstraints()
    }
}

extension MWMovieSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWCardCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWCardCollectionViewCell else { fatalError("Wrong cell") }
        cell.set(movie: self.movies[indexPath.item])
        cell.layoutIfNeeded()
        
        return cell
    }
}
