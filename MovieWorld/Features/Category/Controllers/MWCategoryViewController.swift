//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCategoryViewController: UITableViewController {
    
    // MARK: - Variables
        
    private let sectionUrls: [MWSectionUrl] = [
        MWSectionUrl(name: "Top 250", url: MWURLPaths.nowPlayingMovies),
        MWSectionUrl(name: "Paramount Movies", url: MWURLPaths.popularMovies),
        MWSectionUrl(name: "MyFrenchFilmFestival", url: MWURLPaths.topRatedMovies),
        MWSectionUrl(name: "Post-apocalyptic movies", url: MWURLPaths.upcomingMovies)]
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Category".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isUserInteractionEnabled = true
    }
    
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionUrls.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWCategoryTableViewCell.reuseIdentifier)
            as? MWCategoryTableViewCell ?? MWCategoryTableViewCell()
        cell.section = self.sectionUrls[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
