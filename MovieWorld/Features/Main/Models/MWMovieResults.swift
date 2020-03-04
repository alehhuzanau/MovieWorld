//
//  MWMovieResults.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/4/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

class MWMovieResults: Decodable {
    var page: Int
    var results: [MWMovie]
    
    private enum CodingKeys: String, CodingKey {
        case page, results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.results = try container.decode([MWMovie].self, forKey: .results)
    }
}
