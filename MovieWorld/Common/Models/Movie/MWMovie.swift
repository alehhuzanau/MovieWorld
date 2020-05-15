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
        case id
        case title
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case imageData = "image"
    }

    var id: Int
    var title: String
    var posterPath: String?
    var genreIds: [Int]
    var releaseDate: String
    var imageData: Data? {
        didSet {
            if let data = self.imageData {
                self.image = UIImage(data: data)
            }
        }
    }

    var image: UIImage?

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
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String?.self, forKey: .posterPath) ?? ""
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }

    init(id: Int, title: String, posterPath: String? = nil, genreIds: [Int], releaseDate: String, imageData: Data? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.genreIds = genreIds
        self.releaseDate = releaseDate
        self.imageData = imageData
    }

    func getReleaseDateYear() -> String {
        return String(self.releaseDate.prefix(4))
    }
}
