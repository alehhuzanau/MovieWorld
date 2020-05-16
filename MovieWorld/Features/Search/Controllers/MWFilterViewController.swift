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
    private let yearPickerViewHeight: Int = 250
    private let buttonHeight: Int = 44

    private lazy var genres: [MWGenre] = {
        return (MWSystem.sh.genres ?? [])
    }()

    private var years: [Int] = {
        var years: [Int] = []
        let currentYear = Calendar.current.component(.year, from: Date())
        for year in (1900...currentYear).reversed() {
            years.append(year)
        }

        return years
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
        button.addTarget(self, action: #selector(self.showButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var resetButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Reset".localized,
            style: .plain,
            target: self,
            action: #selector(self.resetButtonTapped))
        button.tintColor = .lightGray

        return button
    }()

    private lazy var rangeSlider: MWYearRangeSlider = {
        let slider = MWYearRangeSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false

        return slider
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: self.view.bounds.width,
                    height: 44)))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.tintColor = .accent
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: "Done".localized,
            style: .done,
            target: self,
            action: #selector(self.yearSelected))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        return toolbar
    }()

    private lazy var yearPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)

        return picker
    }()

    private lazy var pickerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()

    private lazy var navigationOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5

        return view
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
        self.hideSubviews()
    }

    private func addSubviews() {
        self.navigationItem.rightBarButtonItem = self.resetButton
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.countryView)
        self.contentView.addSubview(self.yearView)
        self.contentView.addSubview(self.rangeSlider)
        self.contentView.addSubview(self.showButton)
        self.navigationController?.view.addSubview(self.navigationOverlayView)
        self.navigationController?.view.addSubview(self.pickerContainerView)
        self.pickerContainerView.addSubview(self.yearPickerView)
        self.pickerContainerView.addSubview(self.toolbar)
    }

    private func hideSubviews() {
        self.navigationOverlayView.isHidden = true
        self.pickerContainerView.isHidden = true
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.navigationOverlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.pickerContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        self.yearPickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.yearPickerViewHeight)
        }
        self.toolbar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.yearPickerView.snp.top)
        }
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewHeight)
        }
        self.countryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.yearView.snp.makeConstraints { (make) in
            make.top.equalTo(self.countryView.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.equalToSuperview()
        }
        self.rangeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(self.yearView.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.equalToSuperview()
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
        self.showHidePickerView()
    }

    @objc private func showButtonTapped(_ button: UIButton) {
        self.showButton.alpha = 1
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.showButton.alpha = 0.5
        })
    }

    @objc private func resetButtonTapped(_ button: UIBarButtonItem) {
        self.yearView.descriptionText = nil
        self.collectionView.deselectAllItems(animated: true)
        self.resetButton.tintColor = .lightGray
    }
    
    @objc private func yearSelected(_ sender: UIBarButtonItem) {
        self.showHidePickerView()
        let selectedRow = self.yearPickerView.selectedRow(inComponent: 0)
        self.yearView.descriptionText = String(self.years[selectedRow])
        self.resetButton.tintColor = .accent
    }

    private func showHidePickerView() {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.tabBar.isHidden = !tabBarController.tabBar.isHidden
        self.navigationOverlayView.isHidden = !self.navigationOverlayView.isHidden
        self.pickerContainerView.isHidden = !self.pickerContainerView.isHidden
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
        self.resetButton.tintColor = .accent
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

extension MWFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        String(self.years[row])
    }
}
