//
//  MWMainMoviesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMainMoviesViewController: UIViewController {
    
    // MARK: - Variables
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isUserInteractionEnabled = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    var movies: [Movie] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies".localized
    }
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension MWMainMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMovieCardTableViewCell.reuseIdentifier)
            as? MWMovieCardTableViewCell ?? MWMovieCardTableViewCell()
        cell.set(movie: self.movies[indexPath.row])
        
        return cell
    }
}
