//
//  MWSectionUrl.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/24/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWSection {
    var name: String
    var url: String
    var parameters: [String : String]
    
    init(name: String, url: String, parameters: [String : String] = [:]) {
        self.name = name
        self.url = url
        self.parameters = parameters
    }
}
