//
//  RMService.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/18/24.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singletone instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - expecting: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            print("Using cached API Response")
            let data = cachedResponse.data
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            print("Execute API Request")
            guard let data = data, let response = response, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            if let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode {
                let cachedData = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: urlRequest)
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
