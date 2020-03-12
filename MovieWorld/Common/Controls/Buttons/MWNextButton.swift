//
//  MWNextButton.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWNextButton: MWButton {
    
    override func setupButton() {
        super.setupButton()
        
        let nextIcon = UIImage(named: Constants.ImageName.nextIcon)
        
        self.setTitle("All".localized, for: .normal)
        self.setImage(nextIcon, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard imageView != nil else {
            return
        }
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
    }
}
