//
//  MWMovieResults.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/4/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWMovieResults: Decodable {
    var page: Int
    var results: [MWMovie]
}
