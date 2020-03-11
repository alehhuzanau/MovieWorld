//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWMovie: Decodable {
    var title: String
    var posterPath: String
    var genres: [Int]
    var releaseDate: String
        
    private enum CodingKeys: String, CodingKey {
        case title, posterPath = "poster_path", genres = "genre_ids", releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.genres = try container.decode([Int].self, forKey: .genres)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
