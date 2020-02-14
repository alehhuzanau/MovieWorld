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
    private let subViewEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: -16)

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
            make.top.left.bottom.equalToSuperview().inset(self.subViewEdgeInsets)
            make.width.equalTo(self.imageViewSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.subViewEdgeInsets)
            make.left.equalTo(self.imageView.snp.right).inset(self.subViewEdgeInsets)
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.subViewEdgeInsets.bottom)
            make.left.equalTo(self.imageView.snp.right).inset(self.subViewEdgeInsets)
        }
        self.genresLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(self.subViewEdgeInsets.bottom / 2)
            make.left.equalTo(self.imageView.snp.right).inset(self.subViewEdgeInsets)
        }
        self.ratesLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(self.subViewEdgeInsets)
            make.left.equalTo(self.imageView.snp.right).inset(self.subViewEdgeInsets)
        }
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
