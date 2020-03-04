//
//  MWGenre.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

struct MWGenre: Decodable {
    var id: Int
    var name: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String else { return nil }
        self.id = id
        self.name = name
    }
    
    static func getArray(from jsonArray: Any) -> [MWGenre]? {
        guard let jsonArray = jsonArray as? [String: Any],
            let genres = jsonArray["genres"] as? [[String: Any]] else { return nil }
        
        return genres.compactMap { MWGenre(json: $0) }
    }
}
