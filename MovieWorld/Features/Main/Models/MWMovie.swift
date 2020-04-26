//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWMovie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, title, posterPath = "poster_path", genres = "genre_ids", releaseDate = "release_date"
    }

    var id: Int64
    var title: String
    var posterPath: String?
    var genres: [Int64]
    var releaseDate: String
            
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String?.self, forKey: .posterPath) ?? ""
        self.genres = try container.decode([Int64].self, forKey: .genres)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
