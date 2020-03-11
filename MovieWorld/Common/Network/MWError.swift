//
//  MWError.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/4/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

struct MWError: Decodable {
    var statusCode: Int
    var statusMessage: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.statusMessage = try container.decode(String.self, forKey: .statusMessage)
    }
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code", statusMessage = "status_message"
    }
}
