//
//  MWMovieCardTableViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/14/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWMovieCardTableViewCell: UITableViewCell {

    // MARK: - Variables

    static let reuseIdentifier: String = "MWMovieCardTableViewCell"

    private let subviewsEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    private let imageViewSize = CGSize(width: 70, height: 100)
    private let cellPadding: Int = 3

    // MARK: - GUI variables

    private lazy var movieView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var movieImageView: UIImageView = {
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
        label.font = .boldSystemFont(ofSize: 17.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.alpha = 0.5
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var voteLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
        self.contentView.addSubview(self.movieView)
        self.movieView.addSubview(self.movieImageView)
        self.movieView.addSubview(self.titleLabel)
        self.movieView.addSubview(self.releaseDateLabel)
        self.movieView.addSubview(self.genresLabel)
        self.movieView.addSubview(self.voteLabel)
    }

    // MARK: - Constraints

    override func updateConstraints() {
        self.movieView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.cellPadding)
        }
        self.movieImageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.bottom.lessThanOrEqualToSuperview().inset(self.subviewsEdgeInsets)
            make.size.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.right.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.left.equalTo(self.movieImageView.snp.right).offset(self.subviewsEdgeInsets.left)
        }
        self.releaseDateLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.subviewsEdgeInsets.top)
            make.left.equalTo(self.movieImageView.snp.right).offset(self.subviewsEdgeInsets.left)
            make.right.equalToSuperview().inset(self.subviewsEdgeInsets)
        }
        self.genresLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseDateLabel.snp.bottom).offset(self.subviewsEdgeInsets.top)
            make.left.equalTo(self.movieImageView.snp.right).offset(self.subviewsEdgeInsets.left)
            make.right.equalToSuperview().inset(self.subviewsEdgeInsets)
        }
        self.voteLabel.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.genresLabel.snp.bottom)
                .offset(self.subviewsEdgeInsets.top)
            make.left.equalTo(self.movieImageView.snp.right).offset(self.subviewsEdgeInsets.left)
            make.right.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
        }

        super.updateConstraints()
    }

    // MARK: - Data set methods

    func set(movie: MWMovie) {
        self.titleLabel.text = movie.title
        var subtitleText: String = movie.getReleaseDateYear()
        if let countries = movie.countries, countries.count > 0 {
            countries.forEach { country in
                subtitleText += ", \(country.name)"
            }
        }
        self.releaseDateLabel.text = subtitleText
        self.genresLabel.text = movie.genres
            .map({ $0.name })
            .joined(separator: ", ")
        self.voteLabel.text = "\("User score".localized): \(movie.vote)"
        self.setImage(image: movie.image)

        self.setNeedsUpdateConstraints()
    }

    private func setImage(image: UIImage?) {
        if let image = image {
            self.movieImageView.image = image
            self.movieImageView.contentMode = .scaleAspectFill
        } else {
            self.movieImageView.image = UIImage(named: Constants.ImageName.noPosterIcon)
            self.movieImageView.contentMode = .center
            self.movieImageView.backgroundColor = UIColor.withAlphaComponent(.lightGray)(0.5)
        }
    }
}
