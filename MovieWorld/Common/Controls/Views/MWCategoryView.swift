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

    // MARK: - GUI variables

    private lazy var arrowImageView: UIImageView = {
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
        self.addSubview(self.arrowImageView)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.right.equalTo(self.arrowImageView.snp.left).inset(-self.subviewsEdgeInsets.right)
        }
        self.arrowImageView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.centerY.equalToSuperview()
            make.size.equalTo(self.imageSize)
        }
    }

    // MARK: - Set method

    func set(titleText: String) {
        self.titleLabel.text = titleText
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
