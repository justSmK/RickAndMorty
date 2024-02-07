//
//  RMGetAllLocationsResponse.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/7/24.
//

import Foundation

struct RMGetAllLocationsResponse: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
