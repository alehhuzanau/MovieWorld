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

    // MARK: - Variables

    static let reuseIdentifier = "MWCardCollectionViewCell"

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
            make.top.centerX.width.equalToSuperview()
            make.size.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.updateConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
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
        var subtitleText: String = movie.getReleaseDateYear()
        if let genre = movie.genres.first {
            subtitleText += ", \(genre.name)"
        }
        self.subtitleLabel.text = subtitleText
        self.setImage(image: movie.getImage())

        self.setNeedsUpdateConstraints()
    }

    private func setImage(image: UIImage?) {
        if let image = image {
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.image = UIImage(named: Constants.ImageName.noPosterIcon)
            self.imageView.contentMode = .center
            self.imageView.backgroundColor = UIColor.withAlphaComponent(.lightGray)(0.5)
        }
    }
}
