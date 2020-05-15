//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/15/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWFilterViewController: UIViewController {

    // MARK: - Variables

    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let subviewsInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let buttonHeight: Int = 44

    private lazy var genres: [MWGenre] = {
        return (MWSystem.sh.genres ?? [])
    }()

    var numberOfRows: Int = 2
    var cellPadding: CGFloat = 8

    // MARK: - GUI variables

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = self.collectionViewInsets
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            MWGenreCollectionViewCell.self,
            forCellWithReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier)

        return collectionView
    }()

    private lazy var flowLayout: MWLeftAlignedViewFlowLayout = {
        let layout = MWLeftAlignedViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.delegate = self

        return layout
    }()

    private lazy var collectionViewHeight: CGFloat = {
        guard self.genres.count != 0 else { return 0 }
        let cellHeight = self.sizeForCollectionViewCell().height
        let insetsHeight = self.collectionViewInsets.top + self.collectionViewInsets.bottom
        let rows = CGFloat(self.numberOfRows)

        return cellHeight * rows + self.cellPadding * (rows - 1) + insetsHeight
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var countryView: MWCategoryView = {
        let view = MWCategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(titleText: "Country".localized)

        return view
    }()

    private lazy var yearView: MWCategoryView = {
        let view = MWCategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(titleText: "Year".localized)

        return view
    }()

    private lazy var showButton: MWButton = {
        let button = MWButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.alpha = 0.5

        return button
    }()

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Filter".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.countryView)
        self.contentView.addSubview(self.yearView)
        self.contentView.addSubview(self.showButton)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.collectionViewHeight)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.countryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.yearView.snp.makeConstraints { (make) in
            make.top.equalTo(self.countryView.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.equalToSuperview()
        }
        self.showButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(self.subviewsInsets)
            make.height.equalTo(self.buttonHeight)
        }
    }
}

// MARK: - genres collectionView methods

extension MWFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier,
            for: indexPath)
        (cell as? MWGenreCollectionViewCell)?.set(genre: self.genres[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}

extension MWFilterViewController: MWLeftAlignedDelegateViewFlowLayout {
    private func sizeForCollectionViewCell(labelText: String? = " ") -> CGSize {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude))
        label.font = label.font.withSize(13)
        label.text = labelText
        label.sizeToFit()

        let insets = MWGenreCollectionViewCell.viewInsets
        let width = insets.left + label.frame.width + insets.right
        let height = insets.top + label.frame.height + insets.bottom

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeForCollectionViewCell(labelText: self.genres[indexPath.item].name)
    }
}
