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
    
    // MARK: - GUI Variables
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageName.launchImage)
        
        return imageView
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(named: Constants.ColorName.accentColor)
        indicator.style = .gray
        
        return indicator
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.addSubviews()
        self.makeConstraints()
        
        self.indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MWI.sh.setRootVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.indicator.stopAnimating()
    }
    
    private func addSubviews() {
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.indicator)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(254)
        }
        self.indicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-76)
        }
    }
}
