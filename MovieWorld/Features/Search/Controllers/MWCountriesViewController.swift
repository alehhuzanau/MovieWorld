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
    private let countries: [MWCountry] = MWSystem.sh.countries ?? []

    var countriesSelected: (([MWCountry]) -> Void)?

    // MARK: - GUI variables

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
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
                selectedCountries.append(self.countries[indexPath.row])
            }
            self.countriesSelected?(selectedCountries)
            MWI.sh.popVC()
        }
    }

    // MARK: - check selected rows method

    private func checkSelection() {
        guard self.tableView.indexPathsForSelectedRows != nil else {
            self.selectButton.isEnabled = false
            self.selectButton.alpha = 0.5
            return
        }
        self.selectButton.isEnabled = true
        self.selectButton.alpha = 1
    }
}

extension MWCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWCountryTableViewCell.reuseIdentifier,
            for: indexPath)
        let titleText = self.countries[indexPath.row].name
        (cell as? MWCountryTableViewCell)?.categoryView.titleText = titleText

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkSelection()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.checkSelection()
    }
}
