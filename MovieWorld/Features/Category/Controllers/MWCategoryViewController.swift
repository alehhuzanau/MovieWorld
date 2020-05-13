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

    private let baseSections: [MWSectionsEnum] = [
        .paramountMovies,
        .disasterMovies,
        .postApocalyptic,
        .sonyMovies,
        .aboutKillers,
        .joaquinPhoenix,
        .parentChildRelationships,
        .cyberpunkMovies
    ]

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Category".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(
            MWCategoryTableViewCell.self,
            forCellReuseIdentifier: MWCategoryTableViewCell.reuseIdentifier)

    }

    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baseSections.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWCategoryTableViewCell.reuseIdentifier,
            for: indexPath)
        let titleText = self.baseSections[indexPath.row].getSection().name
        (cell as? MWCategoryTableViewCell)?.set(titleText: titleText)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MWMoviesViewController()
        vc.section = self.baseSections[indexPath.row].getSection()
        MWI.sh.push(vc: vc)
    }
}
