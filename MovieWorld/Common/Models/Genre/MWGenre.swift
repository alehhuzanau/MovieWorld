//
//  MWGenre.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWGenre: Decodable {
    var id: Int
    var name: String
}

extension MWGenre: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
    }
}
