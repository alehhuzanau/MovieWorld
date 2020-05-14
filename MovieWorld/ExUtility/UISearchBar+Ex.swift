//
//  UISearchBar+Ex.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/14/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField {
        return self.value(forKey: "_searchField") as? UITextField ?? UITextField()
    }
}
