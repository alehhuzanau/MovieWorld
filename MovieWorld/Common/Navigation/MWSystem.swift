//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Aleh Huzanau 3/18/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

class MWSystem {
    static let sh = MWSystem()

    var configuration: MWConfiguration?
    var genres: [MWGenre]?
    var countries: [MWCountry]?

    private init() {}
}
