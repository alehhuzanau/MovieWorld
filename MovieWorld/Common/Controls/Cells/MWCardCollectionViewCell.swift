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

    private let edgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    private let imageViewSize = CGSize(width: 130, height: 185)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true

        return imageView
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)

        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension MWCardCollectionViewCell {
    private func configure() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
            make.width.height.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView).inset(self.edgeInsets)
            make.left.equalToSuperview().inset(self.edgeInsets)
        }
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel).inset(self.edgeInsets)
            make.left.bottom.equalToSuperview().inset(self.edgeInsets)
        }
    }
    
    func set(movie: MWMovie) {
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = "\(movie.year), \(movie.genre)"
        self.imageView.image = movie.image
    }
}

