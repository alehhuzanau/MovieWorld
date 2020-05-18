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
    static let sh = MWNetwork()

    private let baseUrl = "https://api.themoviedb.org/3/"
    private let baseParameters: [String: String] = ["api_key": "79d5894567be5b76ab7434fc12879584"]

    private init() { }

    func request<T: Decodable>(
        urlPath: String,
        parameters: [String: String] = [:],
        successHandler: @escaping (T) -> Void,
        errorHandler: @escaping (MWNetError) -> Void) {
        var params = parameters
        params.merge(other: self.baseParameters)
        let url = "\(self.baseUrl)\(urlPath)"
        AF
            .request(url, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    let mwError: MWNetError = .networkError(message: error.localizedDescription)
                    switch error {
                    case .sessionTaskFailed(let error):
                        if (error as? URLError)?.code == URLError.Code.notConnectedToInternet {
                            errorHandler(.connectionIsOffline)
                        } else {
                            errorHandler(mwError)
                        }
                    case .invalidURL:
                        errorHandler(MWNetError.incorrectUrl(url: url))
                    default:
                        errorHandler(mwError)
                    }
                case .success:
                    guard let statusCode = response.response?.statusCode,
                        let data = response.data else {
                            errorHandler(.unknown)
                            return
                    }
                    switch statusCode {
                    case 200..<300:
                        do {
                            let list: T = try JSONDecoder().decode(T.self, from: data)
                            successHandler(list)
                        } catch {
                            errorHandler(.parsingError(message: error.localizedDescription))
                        }
                    case 401, 404:
                        do {
                            let err: MWError = try JSONDecoder().decode(MWError.self, from: data)
                            errorHandler(.error4xx(error: err))
                        } catch {
                            errorHandler(.parsingError(message: error.localizedDescription))
                        }
                    default:
                        errorHandler(.unknown)
                    }
                }
        }
    }

    func downloadImage(_ url: String?, completionHandler: @escaping (Data?) -> Void) {
        guard let imagebaseUrl = MWSystem.sh.configuration?.images.baseUrl, let url = url else {
            completionHandler(nil)
            return
        }
        let imageSize = MWImageSizes.w185
        AF
            .request("\(imagebaseUrl)\(imageSize)\(url)")
            .responseData { response in
                guard let data = response.data else { return }
                completionHandler(data)
        }
    }
}
