//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

struct MWMovie: Decodable {
    var title: String
    var posterPath: String
    var genres: [Int]
    var releaseDate: Int
        
    private enum CodingKeys: String, CodingKey {
        case title, posterPath = "poster_path", genres = "genre_ids", releaseDate = "release_date"
    }
}
