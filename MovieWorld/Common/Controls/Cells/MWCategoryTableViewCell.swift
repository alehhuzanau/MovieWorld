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
    private let subviewsEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 15)
    private let imageSize = CGSize(width: 22, height: 22)
    
    // MARK: - GUI variables
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let image = UIImage(named: Constants.ImageName.arrowIcon)
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.addSubviews()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.arrowImageView)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.viewEdgeInsets)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.right.equalTo(self.arrowImageView.snp.left).inset(-self.subviewsEdgeInsets.right)
        }
        self.arrowImageView.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(self.subviewsEdgeInsets)
            make.size.equalTo(self.imageSize)
        }
    }
    
    // MARK: - Set method
    
    func set(titleText: String) {
        self.titleLabel.text = titleText
    }
    
    // MARK: - setSelected method
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.containerView.backgroundColor = .lightGray
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.containerView.backgroundColor = .white
            })
        }
    }
}
