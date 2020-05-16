//
//  MWButton.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWButton: UIButton {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setupButton()
    }

    private func setupButton() {
        self.backgroundColor = .accent
        self.tintColor = .white
        self.layer.cornerRadius = 5
    }
}
