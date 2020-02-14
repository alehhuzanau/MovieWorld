//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/14/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

typealias Movie = (title: String, image: UIImage, year: Int, country: String, genres: [String], rates: [String : String])

class MWMainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var movie: Movie?
    private let movieViewSize = CGSize(width: 200, height: 150)
    private let movieViewEdgeInsets = UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)
    private let imageViewSize = CGSize(width: 90, height: 150)
    private let subviewEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: -16)

    private lazy var movieView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
            
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
                
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        return self.getSubtitleLabel()
    }()
    
    private lazy var genresLabel: UILabel = {
        let label =  self.getSubtitleLabel()
        label.textColor = .gray

        return label
    }()
    
    private lazy var ratesLabel: UILabel = {
        return self.getSubtitleLabel()
    }()
    
    // MARK: - Life cycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.addSubviews()
        self.makeConstraints()
        //self.makeConstraintsByAnchors()
        
        self.setMovie()
        self.setMovieToViews()
    }
    
    // MARK: - Constraint settings
    
    private func makeConstraints() {
        self.movieView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.movieViewEdgeInsets)
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(self.movieViewSize)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.subviewEdgeInsets)
            make.width.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.subviewEdgeInsets)
            make.left.equalTo(self.imageView.snp.right).inset(self.subviewEdgeInsets)
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.subviewEdgeInsets.bottom)
            make.left.equalTo(self.imageView.snp.right).inset(self.subviewEdgeInsets)
        }
        self.genresLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(self.subviewEdgeInsets.bottom / 2)
            make.left.equalTo(self.imageView.snp.right).inset(self.subviewEdgeInsets)
        }
        self.ratesLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(self.subviewEdgeInsets)
            make.left.equalTo(self.imageView.snp.right).inset(self.subviewEdgeInsets)
        }
    }
    
    private func makeConstraintsByAnchors() {
        self.movieView.translatesAutoresizingMaskIntoConstraints = false
        self.movieView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.movieViewEdgeInsets.left).isActive = true
        self.movieView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0 - self.movieViewEdgeInsets.left).isActive = true
        self.movieView.heightAnchor.constraint(equalToConstant: self.movieViewSize.height).isActive = true
        self.movieView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.movieView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.movieView.topAnchor, constant: self.subviewEdgeInsets.top).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.movieView.leftAnchor, constant: self.subviewEdgeInsets.left).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.movieView.bottomAnchor, constant: 0 - self.subviewEdgeInsets.bottom).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: self.imageViewSize.width).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.movieView.centerYAnchor).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.movieView.topAnchor, constant: self.subviewEdgeInsets.top).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: self.subviewEdgeInsets.left).isActive = true
        
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: self.subviewEdgeInsets.top).isActive = true
        self.subtitleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: self.subviewEdgeInsets.left).isActive = true
    
        self.genresLabel.translatesAutoresizingMaskIntoConstraints = false
        self.genresLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: self.subviewEdgeInsets.top / 2).isActive = true
        self.genresLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: self.subviewEdgeInsets.left).isActive = true
        
        self.ratesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ratesLabel.bottomAnchor.constraint(equalTo: self.movieView.bottomAnchor, constant: 0 - self.subviewEdgeInsets.bottom).isActive = true
        self.ratesLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: self.subviewEdgeInsets.left).isActive = true
    }
    
    // MARK: - Others
        
    private func getSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(13)
        
        return label
    }
    
    private func addSubviews() {
        self.view.addSubview(self.movieView)
        self.movieView.addSubview(self.imageView)
        self.movieView.addSubview(self.titleLabel)
        self.movieView.addSubview(self.subtitleLabel)
        self.movieView.addSubview(self.genresLabel)
        self.movieView.addSubview(self.ratesLabel)
    }
    
    private func setMovie() {
        self.movie = (title: "Green Book",
                      image: UIImage(named: Constants.ImageName.movieImage),
                      year: 2018,
                      country: "USA",
                      genres: ["Comedy", "Drama", "Foreign"],
                      rates: ["IMDB" : "8.2", "KP" : "8.3"]) as? Movie
    }
    
    private func setMovieToViews() {
        self.imageView.image = self.movie?.image
        self.titleLabel.text = self.movie?.title
        self.subtitleLabel.text = "\(self.movie?.year ?? 0), \(self.movie?.country ?? "")"
        self.genresLabel.text = self.movie?.genres.joined(separator:",")
        self.ratesLabel.text = self.movie?.rates.map { $0.0 + " " + $0.1 }.joined(separator: ", ")
    }
}
