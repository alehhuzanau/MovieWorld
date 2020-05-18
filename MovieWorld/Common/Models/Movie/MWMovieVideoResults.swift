//
//  MWMovieVideoResults.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 18.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

class MWMovieVideoResults: Decodable {
    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }

    var videos: [MWMovieVideo]

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.videos = try container.decode([MWMovieVideo].self, forKey: .videos)
    }
}
