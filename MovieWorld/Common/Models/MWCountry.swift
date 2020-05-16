//
//  MWCountry.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 16.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWCountry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case tag = "iso_3166_1"
        case name = "english_name"
    }

    var tag: String
    var name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
