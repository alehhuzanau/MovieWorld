//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import Alamofire

class MWCategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Category"
        self.view.backgroundColor = .green
        
        MWNet.sh.request(urlPath: MWURLPaths.movieGenres,
                         parameters: [:], successHandler: {}, errorHandler: {})
        
    }
}
