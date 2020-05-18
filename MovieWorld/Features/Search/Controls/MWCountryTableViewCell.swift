//
//  MWCountryTableViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 17.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCountryTableViewCell: MWCategoryTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.categoryView.image = UIImage(named: Constants.ImageName.selectedIcon)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.categoryView.isImageViewHidden = !selected
    }
}
