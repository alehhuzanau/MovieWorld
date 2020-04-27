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
    
    private let sectionUrls: [MWSection] = [
        MWSection(name: "Top 250", url: MWURLPaths.discoverMovie),
        MWSection(name: "Paramount Movies",
                     url: MWURLPaths.discoverMovie,
                     parameters: ["with_companies" : "4"]),
        MWSection(name: "Disaster movies",
                     url: MWURLPaths.discoverMovie,
                     parameters: ["with_keywords" : "5096"]),
        MWSection(name: "MyFrenchFilmFestival", url: MWURLPaths.discoverMovie),
        MWSection(name: "Post-apocalyptic movies", url: MWURLPaths.discoverMovie)]
        
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
        
        self.setSections()
    }
    
    // MARK: - DataCore methods
    
    private func setSections() {
        self.sectionUrls.forEach {
            MWCoreDataManager.sh.saveSection(section: $0)
        }
    }
    
    private func getSection(index: Int) -> Section? {
        guard let sections = MWCoreDataManager.sh.fetchSections(),
            let section = sections.first(where: { $0.name == self.sectionUrls[index].name })
            else { return nil }
        
        return section
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
        cell.set(titleText: self.sectionUrls[indexPath.row].name)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MWMoviesViewController()
        vc.section = self.getSection(index: indexPath.row)
        MWI.sh.push(vc: vc)
    }
}
