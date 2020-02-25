//
//  MWMainTabBarController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let mainVC = MWMainViewController()
        let categoryVC = MWCategoryViewController()
        let searchVC = MWSearchViewController()

        self.viewControllers = [mainVC, categoryVC, searchVC]
    }
}
