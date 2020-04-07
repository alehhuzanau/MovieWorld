//
//  MWSection.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/7/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

class MWSection {
    var name: String = ""
    var movies: [MWMovie] = []
    
    init(name: String, movies: [MWMovie]) {
        self.name = name
        self.movies = movies
    }
}
