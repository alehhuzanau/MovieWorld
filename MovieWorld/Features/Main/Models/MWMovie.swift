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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.posterPath, forKey: .posterPath)
        try container.encode(self.genres, forKey: .genres)
        try container.encode(self.releaseDate, forKey: .releaseDate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.genres = try container.decode([Int].self, forKey: .genres)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
