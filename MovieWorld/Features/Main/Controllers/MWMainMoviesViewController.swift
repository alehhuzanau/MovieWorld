//
//  MWMainMoviesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainMoviesViewController: UITableViewController {

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies".localized
    }
}
