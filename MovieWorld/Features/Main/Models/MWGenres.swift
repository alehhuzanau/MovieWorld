//
//  MWGenres.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/4/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWGenres: Decodable {
    var genres: [MWGenre]
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.genres = try container.decode([MWGenre].self, forKey: .genres)
    }
}
