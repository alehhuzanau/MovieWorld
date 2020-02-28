//
//  MWCardCollectionViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MWCardCollectionViewCellIdentifier"

    private let imageViewSize = CGSize(width: 130, height: 185)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func updateConstraints() {
        self.subtitleLabel.snp.updateConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
        self.titleLabel.snp.updateConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.subtitleLabel.snp.top)
        }
        self.imageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview()
            make.size.equalTo(self.imageViewSize)
            make.bottom.equalTo(self.titleLabel.snp.top)
        }
        
        super.updateConstraints()
    }
}

extension MWCardCollectionViewCell {
    private func configure() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
    }
    
    func set(movie: MWMovie) {
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = "\(movie.year), \(movie.genre)"
        self.imageView.image = movie.image
        
        self.setNeedsUpdateConstraints()
    }
}

