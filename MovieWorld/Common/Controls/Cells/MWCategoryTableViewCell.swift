//
//  MWCategoryTableViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/24/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWCategoryTableViewCell: UITableViewCell {

    // MARK: - Variables

    static let reuseIdentifier: String = "MWCategoryTableViewCell"

    private let viewEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

    // MARK: - GUI variables

    lazy var categoryView: MWCategoryView = {
        let view = MWCategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Init methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.contentView.addSubview(self.categoryView)
        self.categoryView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.viewEdgeInsets)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
