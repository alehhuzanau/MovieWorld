//
//  MWCountriesViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 17.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWCountriesViewController: UIViewController {

    // MARK: - Variables

    private let buttonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 10, right: 16)
    private let buttonHeight: Int = 44

    private let headerTitles = ["Popular", "In alphabet order"]
    private let popularSection: Int = 0
    private let baseSection: Int = 1

    private let countries: [[MWCountry]] = {
        let allCountries = MWSystem.sh.countries ?? []
        var popularCountries: [MWCountry] = []
        let popularTags: [String] = ["US", "RU", "SU"]
        popularTags.forEach { tag in
            if let country = allCountries.first(where: { $0.tag == tag }) {
                popularCountries.append(country)
            }
        }
        return [popularCountries, allCountries]
    }()

    var countriesSelected: (([MWCountry]) -> Void)?

    // MARK: - GUI variables

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.sectionFooterHeight = .leastNormalMagnitude
        tableView.sectionHeaderHeight = 49
        tableView.register(
            MWCountryTableViewCell.self,
            forCellReuseIdentifier: MWCountryTableViewCell.reuseIdentifier)

        return tableView
    }()

    private lazy var selectButton: MWButton = {
        let button = MWButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.alpha = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.selectButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Countries".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.selectButton)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.selectButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(self.buttonInsets.top)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(self.buttonInsets)
            make.height.equalTo(self.buttonHeight)
        }
    }

    // MARK: - Tap action method

    @objc private func selectButtonTapped(_ button: UIButton) {
        self.selectButton.alpha = 0.5
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.selectButton.alpha = 1

        })
        if let indexPaths = self.tableView.indexPathsForSelectedRows {
            var selectedCountries: [MWCountry] = []
            indexPaths.forEach { indexPath in
                if indexPath.section == self.baseSection {
                    selectedCountries.append(self.countries[self.baseSection][indexPath.row])
                }
            }
            self.countriesSelected?(selectedCountries)
            MWI.sh.popVC()
        }
    }

    // MARK: - check selected rows methods

    private func checkSelection() {
        guard self.tableView.indexPathsForSelectedRows != nil else {
            self.selectButton.isEnabled = false
            self.selectButton.alpha = 0.5
            return
        }
        self.selectButton.isEnabled = true
        self.selectButton.alpha = 1
    }

    private func getIndexPathOfSameCellInAnotherSection(indexPath: IndexPath) -> IndexPath? {
        let alternativeSection =
            indexPath.section == self.popularSection ? self.baseSection : self.popularSection
        let tag = self.countries[indexPath.section][indexPath.row].tag
        if let row: Int = self.countries[alternativeSection].firstIndex(where: { $0.tag == tag}) {
            return IndexPath(row: row, section: alternativeSection)
        }
        return nil
    }
}

extension MWCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.countries.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.headerTitles[section]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MWCountrySectionView()
        view.titleText = self.headerTitles[section]

        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countries[section].count
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWCountryTableViewCell.reuseIdentifier,
            for: indexPath)
        let titleText = self.countries[indexPath.section][indexPath.row].name
        (cell as? MWCountryTableViewCell)?.categoryView.titleText = titleText

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = self.getIndexPathOfSameCellInAnotherSection(indexPath: indexPath) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        self.checkSelection()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let indexPath = self.getIndexPathOfSameCellInAnotherSection(indexPath: indexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        self.checkSelection()
    }
}
