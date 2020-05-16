//
//  MWYearRangeSlider.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 16.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import RangeSeekSlider

class MWYearRangeSlider: RangeSeekSlider {

    // MARK: - Variables

    private let labelInsets = UIEdgeInsets(top: 6, left: 16, bottom: 0, right: 16)

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 100.0)
    }
    // MARK: - GUI variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Range".localized

        return label
    }()

    private lazy var fromToLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.getRangeText()
        label.alpha = 0.5

        return label
    }()

    // MARK: - subclass setup method

    override func setupStyle() {
        self.tintColor = .lightGray
        self.colorBetweenHandles = UIColor(named: Constants.ColorName.accentColor)
        self.handleColor = .white
        self.handleBorderColor = .lightGray
        self.handleBorderWidth = 0.2
        self.handleDiameter = 28
        self.selectedHandleDiameterMultiplier = 1.0
        self.minDistance = 1
        self.minValue = 0.5
        self.maxValue = 10.5
        self.selectedMinValue = 5
        self.lineHeight = 2
        self.hideLabels = true
        self.delegate = self

        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.fromToLabel)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.labelInsets)
        }
        self.fromToLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(self.labelInsets)
        }
    }

    // MARK: - range text method

    private func getRangeText() -> String {
        let minValue: Int = Int(self.selectedMinValue)
        let maxValue: Int = Int(self.selectedMaxValue)
        let from: String = "from".localized
        let to: String = "to".localized

        return "\(from) \(minValue) \(to) \(maxValue)"
    }
}

extension MWYearRangeSlider: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.fromToLabel.text = self.getRangeText()
    }
}
