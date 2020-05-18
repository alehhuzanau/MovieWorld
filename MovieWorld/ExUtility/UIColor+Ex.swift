//
//  UIColor+Ex.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 16.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

extension UIColor {
    class var accent: UIColor {
        UIColor(named: Constants.ColorName.accentColor) ?? .red
    }
}
