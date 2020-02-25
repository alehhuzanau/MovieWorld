//
//  MWMovieSectionTableViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWMovieSectionTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "MWMovieTableViewCell"
    
    private let edgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: 12, right: -16)
    private let imageViewSize = CGSize(width: 130, height: 185)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        return label
    }()
            
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageName.movieImage)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.movieImageView)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
            
        }
        self.movieImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.bottom.equalToSuperview().inset(self.edgeInsets)
            make.height.width.equalTo(self.imageViewSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        self.titleLabel.text = title
    }
}
