//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/15/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import RangeSeekSlider

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
        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(self.countryViewTapped))
        view.addGestureRecognizer(gesture)

        return view
    }()

    private lazy var yearView: MWCategoryView = {
        let view = MWCategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(titleText: "Year".localized)
        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(self.yearViewTapped))
        view.addGestureRecognizer(gesture)

        return view
    }()

    private lazy var showButton: MWButton = {
        let button = MWButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.alpha = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var resetButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Reset".localized,
            style: .plain,
            target: nil,
            action: nil)
        button.tintColor = .lightGray

        return button
    }()

    private lazy var rangeSlider: RangeSeekSlider = {
        let slider = RangeSeekSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = .lightGray
        slider.colorBetweenHandles = UIColor(named: Constants.ColorName.accentColor)
        slider.handleColor = .white
        slider.handleBorderColor = .lightGray
        slider.handleBorderWidth = 0.2
        slider.handleDiameter = 28
        slider.selectedHandleDiameterMultiplier = 1.0
        slider.minDistance = 1
        slider.minValue = 0
        slider.maxValue = 10
        slider.selectedMinValue = 5
        slider.step = 1
        slider.lineHeight = 2
        slider.hideLabels = true
        slider.delegate = self

        return slider
    }()

    private lazy var fromToLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.getFromToLabelText()
        label.alpha = 0.5

        return label
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
        self.contentView.addSubview(self.rangeSlider)
        self.rangeSlider.addSubview(self.fromToLabel)
        self.contentView.addSubview(self.showButton)
        self.navigationItem.rightBarButtonItem = self.resetButton
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
        self.rangeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(self.yearView.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        self.fromToLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(6)
            make.right.equalToSuperview().inset(16)
        }
        self.showButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(self.subviewsInsets)
            make.height.equalTo(self.buttonHeight)
        }
    }

    // MARK: - Tap action methods

    @objc private func countryViewTapped(_ sender: UITapGestureRecognizer) {
        self.countryView.animateTap()
    }

    @objc private func yearViewTapped(_ sender: UITapGestureRecognizer) {
        self.yearView.animateTap()
    }

    @objc private func showButtonTapped(_ button: UIButton) {
        self.showButton.alpha = 1
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.showButton.alpha = 0.5
        })
    }

    private func getFromToLabelText() -> String {
        let minValue: Int = Int(self.rangeSlider.selectedMinValue)
        let maxValue: Int = Int(self.rangeSlider.selectedMaxValue)
        let from: String = "from".localized
        let to: String = "to".localized

        return "\(from) \(minValue) \(to) \(maxValue)"
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

extension MWFilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.fromToLabel.text = self.getFromToLabelText()
    }
}
