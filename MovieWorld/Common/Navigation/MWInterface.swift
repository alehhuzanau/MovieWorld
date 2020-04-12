//
//  MWInterface.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

typealias MWI = MWInterface

class MWInterface {
    
    static let sh = MWInterface()
    
    private weak var window: UIWindow?
    
    private lazy var tabBarController = MWMainTabBarController()
    
    private init() {}
    
    func setup(window: UIWindow) {
        self.window = window
        
        self.setUpNavigationBarStyle()
        
        window.rootViewController = MWInitController()
        window.makeKeyAndVisible()
    }
    
    private func setUpNavigationBarStyle() {
        let standardNavBar = UINavigationBar.appearance()
        standardNavBar.backgroundColor = .white
        standardNavBar.tintColor = UIColor(named: Constants.ColorName.accentColor)
        standardNavBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let newNavBar = UINavigationBarAppearance()
            newNavBar.configureWithDefaultBackground()
            
            standardNavBar.scrollEdgeAppearance = newNavBar
        }
    }
    
    func push(vc: UIViewController) {
        let navigationVC = self.tabBarController.selectedViewController as? UINavigationController
        navigationVC?.navigationBar.topItem?.title = ""
        navigationVC?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        let navigationVC = self.tabBarController.selectedViewController as? UINavigationController
        navigationVC?.popViewController(animated: true)
    }
    
    func setRootVC() {
        self.window?.rootViewController = self.tabBarController
    }
}
