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

    var movie: MWMovie? {
        willSet {
            if let movie = newValue {
                self.movieView.set(movie: movie)
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
    }
}
