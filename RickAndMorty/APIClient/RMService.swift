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
        
    }
}
