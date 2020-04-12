//
//  MWMainMoviesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainMoviesViewController: UITableViewController {
    
    // MARK: - Variables
    
    private let edgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    
    var movies: [Movie] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies".localized
        
        self.tableView.contentInset = self.edgeInsets
    }
    
    // MARK: - TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.movies[indexPath.row].title
        
        return cell
    }
}
