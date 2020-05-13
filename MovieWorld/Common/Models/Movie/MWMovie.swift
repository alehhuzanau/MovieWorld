//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 2/25/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWMovie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, title, posterPath = "poster_path", genreIds = "genre_ids", releaseDate = "release_date"
    }

    var id: Int64
    var title: String
    var posterPath: String?
    var genreIds: [Int]
    var releaseDate: String
    var image: Data?

    lazy var genres: [MWGenre] = {
        var genres: [MWGenre] = []
        if let allGenres = MWSystem.sh.genres {
            allGenres
                .filter { self.genreIds.contains($0.id) }
                .forEach { genres.append($0) }
        }
        return genres
    }()

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String?.self, forKey: .posterPath) ?? ""
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }

    func getImage() -> UIImage? {
        if let data = self.image {
            return UIImage(data: data)
        }
        return nil
    }

    func getReleaseDateYear() -> String {
        return String(self.releaseDate.prefix(4))
    }
}
