//
//  APICaller.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

enum APIError: Error {
    case badData
    case badResponse(statusCode: Int)
    case failedToDecode
    case error(errorCode: Int, description: String)
}

protocol APICaller {
    var task: URLSessionDataTask? { get set }
    func get<T: Decodable>(withDataTask task: inout URLSessionDataTask?, request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void)
}

extension APICaller {
    
    func get<T: Decodable>(withDataTask task: inout URLSessionDataTask?, request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                return completion(.failure(.error(errorCode: error._code, description: error.localizedDescription)))
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            if let response = response as? HTTPURLResponse {
                guard 200..<300 ~= response.statusCode else {
                    return completion(.failure(.badResponse(statusCode: response.statusCode)))
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.failedToDecode))
            }
                                                            
        }
        task!.resume()
    }
}
