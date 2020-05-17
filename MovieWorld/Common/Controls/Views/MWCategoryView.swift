//
//  MWCategoryView.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/15/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCategoryView: UIView {

    // MARK: - Variables

    private let subviewsEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 15)
    private let imageSize = CGSize(width: 22, height: 22)
    private let distanceBetweenLabels: Int = 38

    var titleText: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }

    var descriptionText: String? {
        get {
            return self.descriptionLabel.text
        }
        set {
            self.descriptionLabel.text = newValue
        }
    }

    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }

    var isImageViewHidden: Bool {
        get {
            return self.imageView.isHidden
        }
        set {
            self.imageView.isHidden = newValue
        }
    }

    // MARK: - GUI variables

    private lazy var imageView: UIImageView = {
        let image = UIImage(named: Constants.ImageName.arrowIcon)
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .right
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.alpha = 0.5
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Init methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.initialize()
    }

    private func initialize() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.imageView)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.left.equalTo(self.titleLabel.snp.right).offset(self.distanceBetweenLabels)
            make.right.equalTo(self.imageView.snp.left)
        }
        self.imageView.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.size.equalTo(self.imageSize)
        }
    }

    // MARK: - Tap animation action

    func animateTap() {
        self.backgroundColor = .lightGray
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.backgroundColor = .white
        })
    }
}
