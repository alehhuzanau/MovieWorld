//
//  MWGenreCollectionViewCell.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWGenreCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MWGenreCollectionViewCell"

    // MARK: - Variables
    
    private let edgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

    // MARK: - GUI variables

    private lazy var genreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Constants.ColorName.accentColor)
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5

        return view
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    // MARK: - Init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.genreView)
        self.genreView.addSubview(self.genreLabel)
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.genreView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        self.genreLabel.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }

        super.updateConstraints()
    }
    
    // MARK: - Data set methods
    
    func set(movie: Movie) {
        self.genreLabel.text = movie.title
        
        self.setNeedsUpdateConstraints()
    }
}
