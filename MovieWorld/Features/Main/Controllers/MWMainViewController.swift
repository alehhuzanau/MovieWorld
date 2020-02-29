//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit


typealias MWSection = (name: String, movies: [MWMovie])

class MWMainViewController: UITableViewController {
        
    private let sections: [MWSection] = {
        let image = UIImage(named: Constants.ImageName.movieImage)
        let movies: [MWMovie] = [
            MWMovie(title: "21 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "The Good Liar", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "Terminator: D...", image: image!, genre: "Adventures", year: 2019),
            MWMovie(title: "21 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "21 Bridges", image: image!, genre: "Drama", year: 2019),
            MWMovie(title: "21 Bridges", image: image!, genre: "Drama", year: 2019)
        ]
        
        return [
            MWSection(name: "New", movies: movies),
            MWSection(name: "Movies", movies: movies),
            MWSection(name: "Series and shows", movies: movies),
            MWSection(name: "Animated movies", movies: movies)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Season"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isUserInteractionEnabled = true
        self.tableView.rowHeight = 305
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier) as? MWMovieSectionTableViewCell ?? MWMovieSectionTableViewCell()
        
        cell.set(section: self.sections[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}
