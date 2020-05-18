//
//  MWImages.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/18/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWImages: Decodable {
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url", posterSizes = "poster_sizes"
    }

    var baseUrl: String
    var posterSizes: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseUrl = try container.decode(String.self, forKey: .baseUrl)
        self.posterSizes = try container.decode([String].self, forKey: .posterSizes)
    }
}
