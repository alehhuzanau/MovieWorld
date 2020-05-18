//
//  MWCountrySectionView.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 17.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCountrySectionView: UIView {
    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)

    var titleText: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

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
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.insets)
        }
    }
}
