//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/15/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWFilterViewController: UIViewController {

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Filter".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
