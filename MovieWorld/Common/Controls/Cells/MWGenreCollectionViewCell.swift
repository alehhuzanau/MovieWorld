//
//  MWGenreCollectionViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWGenreCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables

    static let reuseIdentifier = "MWGenreCollectionViewCell"

    static let viewInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.genreView.alpha = 1
            } else {
                self.genreView.alpha = 0.5
            }
        }
    }

    // MARK: - GUI variables

    private lazy var genreView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5

        return view
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = .white
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
        self.contentView.addSubview(self.genreView)
        self.genreView.addSubview(self.genreLabel)
    }

    // MARK: - Constraints

    override func updateConstraints() {
        self.genreView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        self.genreLabel.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(MWGenreCollectionViewCell.viewInsets)
        }

        super.updateConstraints()
    }

    // MARK: - Data set methods

    func set(genre: MWGenre) {
        self.genreLabel.text = genre.name

        self.setNeedsUpdateConstraints()
    }
}
