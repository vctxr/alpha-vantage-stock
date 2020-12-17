//
//  AlphaVantageAPI.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

final class AlphaVantageAPI: APICaller {
    
    var task: URLSessionDataTask?
    
    func fetch<T: Decodable>(with endpoint: AlphaVantageEndpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        let request = endpoint.urlRequest
        print("Requesting with url: \(request)")
        get(withDataTask: &task, request: request, completion: completion)
    }
}
