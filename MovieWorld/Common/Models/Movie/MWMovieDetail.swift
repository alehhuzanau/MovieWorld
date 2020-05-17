//
//  MWMovieDetail.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 17.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWMovieDetail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case countries = "production_countries"
    }

    var countries: [MWProductionCountry]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countries = try container.decode([MWProductionCountry].self, forKey: .countries)
    }
}
