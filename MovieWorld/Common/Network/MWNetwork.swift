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
    
    func request<T: Decodable>(urlPath: String,
                               parameters: [String : String] = [:],
                               successHandler: @escaping (T) -> Void,
                               errorHandler: @escaping (MWNetError) -> Void) {
        var params = parameters
        params.merge(other: self.baseParameters)
        let url = "\(self.baseUrl)\(urlPath)"
        
        AF.request(
            url,
            parameters: params).responseJSON { response in
                let isConnectedToInternet: Bool = NetworkReachabilityManager()?.isReachable ?? false
                if !isConnectedToInternet {
                    self.handleClosure(
                        errorHandler,
                        .networkError(message: "No Internet Connection"))
                    return
                }
                if let error = response.error {
                    switch error {
                    case .invalidURL(_):
                        self.handleClosure(errorHandler, MWNetError.incorrectUrl(url: url))
                        break
                    default:
                        self.handleClosure(
                            errorHandler,
                            .networkError(message: error.localizedDescription))
                    }
                    return
                }
                guard let statusCode = response.response?.statusCode,
                    let data = response.data else {
                        self.handleClosure(errorHandler, .unknown)
                        return
                }
                switch statusCode {
                case 200..<300:
                    do {
                        let list: T = try JSONDecoder().decode(T.self, from: data)
                        self.handleClosure(successHandler, list)
                    } catch {
                        self.handleClosure(
                            errorHandler,
                            .parsingError(message: error.localizedDescription))
                    }
                    break
                case 401, 404:
                    do {
                        let err: MWError = try JSONDecoder().decode(MWError.self, from: data)
                        self.handleClosure(errorHandler, .error4xx(error: err))
                    } catch {
                        self.handleClosure(
                            errorHandler,
                            .parsingError(message: error.localizedDescription))
                    }
                    break
                default:
                    self.handleClosure(errorHandler, .unknown)
                    return
                }
        }
    }
    
    private func handleClosure<T>(_ handler: @escaping (T) -> Void, _ result: T) {
        DispatchQueue.main.async {
            handler(result)
        }
    }
    
    func downloadImage(_ url: String?, handler: @escaping (Data?) -> Void) {
        guard let imagebaseUrl = MWSystem.sh.configuration?.images.baseUrl, let url = url else {
            self.handleClosure(handler, nil)
            return
        }
        let imageSize = MWImageSizes.w185
        AF.request("\(imagebaseUrl)\(imageSize)\(url)").responseData { response in
            guard let data = response.data else { return }
            self.handleClosure(handler, data)
        }
    }
}
