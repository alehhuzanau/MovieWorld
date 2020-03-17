//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/12/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import SnapKit

class MWInitController: UIViewController {
    
    // MARK: - Variables
    
    private let dispatchGroup = DispatchGroup()
    
    private var genres = MWGenres(genres: [])
    
    // MARK: - GUI Variables
    
    private lazy var contentView: UIView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Season".localized
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageName.launchImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(named: Constants.ColorName.accentColor)
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .gray
        }
        
        return indicator
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.addSubviews()
        self.makeConstraints()
        
        self.indicator.startAnimating()
        
        self.fetchGenres(urlPath: MWURLPaths.movieGenres)
        self.fetchGenres(urlPath: MWURLPaths.tvGenres)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dispatchGroup.notify(queue: .main) {
            self.genres.genres = Array(Set(self.genres.genres))
            print(self.genres.genres)
            
            MWI.sh.setRootVC()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.indicator.stopAnimating()
    }
    
    private func addSubviews() {
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.imageView)
        self.view.addSubview(self.indicator)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(42)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
            make.height.equalTo(254)
        }
        self.indicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-76)
        }
    }
    
    // MARK: - Requests
    
    private func fetchGenres(urlPath: String) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: urlPath,
            successHandler: { [weak self] (genres: MWGenres) in
                self?.genres.genres += genres.genres
                self?.dispatchGroup.leave()
            },
            errorHandler: { error in
                print(error.getDescription())
        })
    }
}
