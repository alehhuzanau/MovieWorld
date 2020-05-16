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

    private let imageSize = CGSize(width: 295, height: 254)
    private let edgeInsets = UIEdgeInsets(top: 42, left: 40, bottom: 42, right: 40)

    private let dispatchGroup = DispatchGroup()

    private var genres: [MWGenre] = []

    // MARK: - GUI Variables

    private lazy var contentView: UIView = {
        let view = UIView()
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
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .whiteLarge
        }
        indicator.color = .accent

        return indicator
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()

        self.indicator.startAnimating()
        self.setConfiguration()
        self.fetchGenres(urlPath: MWURLPaths.movieGenres)
        self.dispatchGroup.notify(queue: .main) {
            if self.genres.count != 0 {
                MWCoreDataManager.sh.deleteAllGenres()
            }
            for genre in self.genres {
                MWCoreDataManager.sh.saveGenre(id: genre.id, name: genre.name)
            }
            MWSystem.sh.genres = self.genres
            self.indicator.stopAnimating()
            MWI.sh.setRootVC()
        }
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
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(self.edgeInsets)
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.imageSize.height)
        }
        self.indicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(self.edgeInsets.bottom)
        }
    }

    // MARK: - Requests

    private func setConfiguration() {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: MWURLPaths.configuration,
            successHandler: { [weak self] (configuration: MWConfiguration) in
                MWSystem.sh.configuration = configuration
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self]  error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }

    private func fetchGenres(urlPath: String) {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: urlPath,
            successHandler: { [weak self] (genres: MWGenreResults) in
                self?.genres = genres.genres
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self]  error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }
}
