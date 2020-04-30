//
//  MWButton.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWButton: UIButton {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupButton()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setupButton()
    }

    open func setupButton() {
        self.backgroundColor = UIColor(named: Constants.ColorName.accentColor)
        self.tintColor = .white
        self.layer.cornerRadius = 5
    }
}
