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
        
    // MARK: - Variables
    
    private var sections = [MWSection]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Season"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isUserInteractionEnabled = true
        self.tableView.rowHeight = 305
        
        self.initRequest()
    }
    
    // MARK: - Request methods
    
    private func initRequest() {
        self.request(sectionName: "Now Playing", urlPath: MWURLPaths.nowPlayingMovies)
        self.request(sectionName: "Popular Movies", urlPath: MWURLPaths.popularMovies)
        self.request(sectionName: "Top Rated Movies", urlPath: MWURLPaths.topRatedMovies)
        self.request(sectionName: "Upcoming Movies", urlPath: MWURLPaths.upcomingMovies)
    }
    
    private func request(sectionName: String, urlPath: String) {
        let successHandler: (MWMovieResults) -> Void = { [weak self] results in
            self?.sections.append(MWSection(name: sectionName, movies: results.results))
            self?.tableView.reloadData()
        }
        let errorHandler: (MWNetError) -> Void = { error in
            print(error.getDescription())
        }
        MWNet.sh.request(urlPath: urlPath,
                         parameters: [:],
                         successHandler: successHandler,
                         errorHandler: errorHandler)
    }
    
    // MARK: - TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieSectionTableViewCell.reuseIdentifier)
            as? MWMovieSectionTableViewCell ?? MWMovieSectionTableViewCell()
        
        cell.set(section: self.sections[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}
