//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/3/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit
import Alamofire

typealias MWNet = MWNetwork

class MWNetwork {
    private static let apiKey = "79d5894567be5b76ab7434fc12879584"
    private let baseUrl = "https://api.themoviedb.org/3/"
    private let baseParameters: [String : String] = ["api_key" : apiKey]
    
    static let sh = MWNetwork()
    
    private init() {}
    
    func request(urlPath: String,
                 parameters: [String : String],
                 successHandler: @escaping () -> Void,
                 errorHandler: @escaping () -> Void) {
        var params = parameters
        params.merge(other: self.baseParameters)
        let url = self.getUrlWithParams(fullPath: "\(self.baseUrl)\(urlPath)", params: params)
        
        AF.request(url).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else {
                // - TODO: call errorHandler
                errorHandler()
                return
            }
            print("statusCode: ", statusCode)
            switch statusCode {
            case 200..<300:
                //print(responseJSON)
                
                switch responseJSON.result {
                case .success(let value):
                    let genres = MWGenre.getArray(from: value)
                    print(genres)
                default:
                    print("error")
                }
                break
            case 401:
                break
            case 404:
                break
            default: return
            }
        }
    }
}
