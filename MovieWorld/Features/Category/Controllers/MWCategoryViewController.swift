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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        let successHandler: (MWGenres) -> Void = { genres in
            genres.genres.forEach { print($0) }
        }
        let errorHandler: (MWNetError) -> Void = { error in
            print(error.getDescription())
        }
        
        MWNet.sh.request(urlPath: MWURLPaths.movieGenres,
                         parameters: [:],
                         successHandler: successHandler,
                         errorHandler: errorHandler)
    }
}
