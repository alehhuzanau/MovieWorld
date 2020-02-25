//
//  AppDelegate.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/14/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        MWI.sh.setup(window: self.window!)
        
        return true
    }
}

