//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainViewController: UITableViewController {
    
    private let sections = ["New", "Movies", "Series and shows", "Animated movies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Season"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isUserInteractionEnabled = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier) as? MWMovieSectionTableViewCell ?? MWMovieSectionTableViewCell()
        
        cell.set(title: self.sections[indexPath.row])
        
        return cell
    }
}
