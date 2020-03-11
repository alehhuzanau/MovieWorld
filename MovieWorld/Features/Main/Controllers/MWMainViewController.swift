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
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: Constants.ColorName.accentColor)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

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
        MWNet.sh.request(
            urlPath: urlPath,
            successHandler: { [weak self] (results: MWMovieResults) in
                self?.sections.append(MWSection(name: sectionName, movies: results.results))
                self?.tableView.reloadData()
            },
            errorHandler: { error in
                print(error.getDescription())
        })
    }

    // MARK: - RefreshControl action
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        self.sections.removeAll()
        self.initRequest()
        
        refreshControl.endRefreshing()
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
        cell.selectionStyle = .none
        cell.set(section: self.sections[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
