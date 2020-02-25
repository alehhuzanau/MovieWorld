//
//  MWMainTabBarController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainTabBarController: UITabBarController {
    
    private lazy var mainTabBarItem = UITabBarItem(title: "Main",
                                                   image: UIImage(named: Constants.ImageName.mainIcon),
                                                   tag: 0)

    private lazy var categoryTabBarItem = UITabBarItem(title: "Category",
                                                   image: UIImage(named: Constants.ImageName.categoryIcon),
                                                   tag: 1)
    
    private lazy var searchTabBarItem = UITabBarItem(title: "Search",
                                                   image: UIImage(named: Constants.ImageName.searchIcon),
                                                   tag: 2)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MWMainViewController()
        mainVC.tabBarItem = self.mainTabBarItem

        let categoryVC = MWCategoryViewController()
        categoryVC.tabBarItem = self.categoryTabBarItem

        let searchVC = MWSearchViewController()
        searchVC.tabBarItem = self.searchTabBarItem

        let controllers = [mainVC, categoryVC, searchVC]
        self.viewControllers = controllers
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
}
