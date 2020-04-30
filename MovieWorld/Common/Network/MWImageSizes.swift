//
//  MWImageSizes.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/18/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

enum MWImageSizes: String, Decodable {
    case w45, w92, w154, w185, w300, w500, original, unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try MWImageSizes(rawValue: (container.decode(RawValue.self))) ?? .unknown
    }
}
