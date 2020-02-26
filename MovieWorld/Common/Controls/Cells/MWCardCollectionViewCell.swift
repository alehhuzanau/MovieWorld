//
//  MWCardCollectionViewCell.swift
//  MovieWorld
//
//  Created by student4 on 2/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MWCardCollectionViewCellIdentifier"

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension MWCardCollectionViewCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}

