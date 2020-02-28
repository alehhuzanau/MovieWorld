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
    
    private var dataSource: [MWMovie] = {
        let image = UIImage(named: Constants.ImageName.movieImage)
        
        return [
            MWMovie(title: "21 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "22 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "23 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "24 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "25 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "26 Bridges", image: image!, genre: "Drama", year: 2019)
        ]
    }()
    
    private let edgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 7)
    private let buttonSize = CGSize(width: 52, height: 24)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWCardCollectionViewCell.self,
                                forCellWithReuseIdentifier: MWCardCollectionViewCell.reuseIdentifier)

        return collectionView
    }()
    
    private lazy var allButton: UIButton = MWNextButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        self.addSubview(self.collectionView)
        self.addSubview(self.allButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        self.titleLabel.text = title
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
        }
        self.allButton.snp.updateConstraints { (make) in
            make.top.right.equalToSuperview().inset(self.edgeInsets)
            make.size.equalTo(self.buttonSize)
            make.bottom.equalTo(self.titleLabel.snp.bottom)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.bottom.right.equalToSuperview()
        }

        super.updateConstraints()
    }
}

extension MWMovieSectionTableViewCell {
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        return layout
    }
}

extension MWMovieSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWCardCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? MWCardCollectionViewCell else { fatalError("Wrong cell") }
        cell.set(movie: self.dataSource[indexPath.item])
        cell.layoutIfNeeded()
        
        return cell
    }
}
