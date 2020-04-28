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
    
    // MARK: - Variables
    
    static let reuseIdentifier: String = "MWMovieSectionTableViewCell"
    
    private let edgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 7)
    private let buttonSize = CGSize(width: 52, height: 24)
    
    private var movies: [Movie] = []
    
    @objc var pushVC: (() -> Void)? = nil
    
    // MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.flowLayout)
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
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 237)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
        
        return layout
    }()
    
    private lazy var allButton: UIButton = {
        let button = MWNextButton(type: .system)
        button.addTarget(self, action: #selector(self.allButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.allButton)
        self.addSubview(self.collectionView)
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
            make.right.equalTo(self.allButton.snp.left)
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
    
    // MARK: - Data set methods
    
    func set(section: Section) {
        self.titleLabel.text = section.name?.localized
        self.movies = section.getMovies()
        
        self.setNeedsUpdateConstraints()
    }
    
    @objc func allButtonTapped(_ button: UIButton) {
        self.pushVC?()
    }
}

extension MWMovieSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWCardCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWCardCollectionViewCell ?? MWCardCollectionViewCell()
        cell.set(movie: self.movies[indexPath.item])
        
        return cell
    }
}
