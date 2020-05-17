//
//  MWProductionCountry.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 16.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWProductionCountry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case tag = "iso_3166_1"
        case name = "name"
    }

    var tag: String
    var name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
