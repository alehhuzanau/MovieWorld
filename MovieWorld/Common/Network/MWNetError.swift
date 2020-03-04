//
//  MWNetError.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

enum MWNetError {
    case incorrectUrl(url: String)
    case networkError(message: String)
    case serverError(statusCode: Int)
    case parsingError(message: String)
    case error4xx(error: MWError)
    case unknown
    
    func getDescription() -> String {
        switch self {
        case .incorrectUrl(let url):
            return "incorrect url: \(url)"
        case .networkError(let message):
            return "network error: \(message)"
        case .parsingError(let message):
            return "parsing error: \(message)"
        case .serverError(let statusCode):
            return "server error with \(statusCode) status code"
        case .error4xx(let error):
            return "4xx error \(error.statusCode): \(error.statusMessage)"
        default:
            return "unknown"
        }
    }
}
