//
//  MWMovieInfoViewController.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 18.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMovieInfoViewController: UIViewController {

    // MARK: - Variables

    private let movieViewInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    private let webViewInsets = UIEdgeInsets(top: 18, left: 16, bottom: 24, right: 16)
    private let subviewsInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let webViewHeight: Int = 166
    private let siteName = "YouTube"

    var movie: MWMovie? {
        willSet {
            if let movie = newValue {
                self.movie = movie
                self.movieView.set(movie: movie)
                self.loadDetails()
                self.loadVideos()
            }
        }
    }

    // MARK: - GUI variables

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false

        return view
    }()

    private lazy var movieView: MWMovieInfoView = {
        let view = MWMovieInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: -3, height: 4)

        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "Description".localized
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.alpha = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var webView: UIWebView = {
        let view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        if #available(iOS 13.0, *) {
            view.largeContentImage = UIImage(named: Constants.ImageName.noPosterIcon)
        }

        return view
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        self.addSubviews()
        self.makeConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.movieView)
        self.scrollView.addSubview(self.webView)
        self.scrollView.addSubview(self.descriptionLabel)
        self.scrollView.addSubview(self.runtimeLabel)
        self.scrollView.addSubview(self.overviewLabel)
    }

    // MARK: - Constraints

    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.movieView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(self.movieViewInsets)
            make.width.equalToSuperview()
        }
        self.webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieView.snp.bottom)
            make.left.right.equalToSuperview().inset(self.webViewInsets)
            make.height.equalTo(0)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.webView.snp.bottom).offset(self.webViewInsets.bottom)
            make.left.right.equalToSuperview().inset(self.subviewsInsets)
        }
        self.runtimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.equalToSuperview().inset(self.subviewsInsets)
        }
        self.overviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.runtimeLabel.snp.bottom).offset(self.subviewsInsets.top)
            make.left.right.bottom.equalToSuperview().inset(self.subviewsInsets)
        }
    }

    private func remakeConstraints() {
        self.webView.snp.updateConstraints { (make) in
            make.top.equalTo(self.movieView.snp.bottom).offset(self.webViewInsets.top)
            make.height.equalTo(self.webViewHeight)
        }
    }

    // MARK: - Request method

    private func loadDetails() {
        guard let movie = self.movie else { return }
        let url = "\(MWURLPaths.movieDetails)\(movie.id)"
        MWNet.sh.request(
            urlPath: url,
            successHandler: { [weak self] (detail: MWMovieDetail) in
                self?.runtimeLabel.text = "\(detail.runtime ?? 0) \("minutes".localized)"
                self?.overviewLabel.text = detail.overview ?? ""
            },
            errorHandler: { error in
                print(error.getDescription())
        })
    }

    private func loadVideos() {
        guard let movie = self.movie else { return }
        let url = "\(MWURLPaths.movieDetails)\(movie.id)\(MWURLPaths.videos)"
        MWNet.sh.request(
            urlPath: url,
            successHandler: { [weak self] (result: MWMovieVideoResults) in
                let videos = result.videos
                if let firstVideo = videos.first, firstVideo.site == self?.siteName {
                    self?.remakeConstraints()
                    self?.loadYoutube(videoID: firstVideo.key)
                }
            },
            errorHandler: { error in
                print(error.getDescription())
        })
    }

    private func loadYoutube(videoID: String) {
        guard let url = URL(string: "\(MWURLPaths.youtube)\(videoID)") else { return }
        self.webView.loadRequest(URLRequest(url: url))
    }
}
