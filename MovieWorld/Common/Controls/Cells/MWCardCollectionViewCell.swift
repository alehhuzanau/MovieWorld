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

    // MARK: - Variables
    
    private let imageViewSize = CGSize(width: 130, height: 185)

    // MARK: - GUI variables
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.imageView.snp.updateConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.updateConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).inset(-12)
            make.left.right.equalToSuperview()
            make.width.lessThanOrEqualTo(self.imageViewSize.width)
        }
        self.subtitleLabel.snp.updateConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(self.imageViewSize.width)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Data set methods
    
    func set(movie: MWMovie) {
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = "\(movie.releaseDate.prefix(4)), Drama"
        
        MWNet.sh.downloadImage(
            movie.posterPath,
            successHandler: { [weak self] image in
                self?.imageView.image = image
        })
        
        self.setNeedsUpdateConstraints()
    }
}
