//
//  MWMovieResults.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/4/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

class MWMovieResults: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case movies = "results"
    }

    var totalPages: Int
    var movies: [MWMovie]

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.movies = try container.decode([MWMovie].self, forKey: .movies)
    }
}
