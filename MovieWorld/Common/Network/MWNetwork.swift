//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

typealias MWNet = MWNetwork

class MWNetwork {
    static let apiKey = "79d5894567be5b76ab7434fc12879584"
    static let baseUrl = "https://developers.themoviedb.org/3/"
    
    static let sh = MWNetwork()
    
    private init() {}
    
    func request(urlPath: String,
                 parameters: [String : String],
                 successHandler: () -> Void,
                 errorHandler: () -> Void) {
        
    }
}
