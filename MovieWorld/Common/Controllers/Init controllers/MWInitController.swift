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

        self.sendRequests()
    }

    private func addSubviews() {
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.imageView)
        self.view.addSubview(self.indicator)
    }

    private func sendRequests() {
        self.indicator.startAnimating()
        self.setConfiguration()
        self.setGenres()
        self.setCountries()
        self.dispatchGroup.notify(queue: .main) {
            self.indicator.stopAnimating()
            MWI.sh.setRootVC()
        }
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

    private func setGenres() {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: MWURLPaths.movieGenres,
            successHandler: { [weak self] (result: MWGenreResults) in
                MWSystem.sh.genres = result.genres
                MWCoreDataManager.sh.deleteAllGenres()
                result.genres.forEach { genre in
                    MWCoreDataManager.sh.saveGenre(id: genre.id, name: genre.name)
                }
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self]  error in
                print(error.getDescription())
                self?.setGenresFromCoreData()
                self?.dispatchGroup.leave()
        })
    }

    private func setCountries() {
        self.dispatchGroup.enter()
        MWNet.sh.request(
            urlPath: MWURLPaths.countries,
            successHandler: { [weak self] (countries: [MWCountry]) in
                MWSystem.sh.countries = countries.sorted { $0.name < $1.name }
                self?.dispatchGroup.leave()
            },
            errorHandler: { [weak self]  error in
                print(error.getDescription())
                self?.dispatchGroup.leave()
        })
    }

    // MARK: - Others

    private func setGenresFromCoreData() {
        guard let coreGenres = MWCoreDataManager.sh.fetchGenres() else { return }
        var genres: [MWGenre] = []
        coreGenres.forEach { coreGenre in
            genres.append(coreGenre.getGenre())
        }
        MWSystem.sh.genres = genres
    }
}
