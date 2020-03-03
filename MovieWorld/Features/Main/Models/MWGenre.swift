//
//  MWGenre.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

struct MWGenre: Encodable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(genre: MWGenre) {
        self.id = genre.id
        self.name = genre.name
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String
        else {
            return nil
        }
        self.id = id
        self.name = name
    }
    
    static func getArray(from jsonArray: Any) -> [MWGenre]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return jsonArray.flatMap { MWGenre(json: $0) }
    }
}
