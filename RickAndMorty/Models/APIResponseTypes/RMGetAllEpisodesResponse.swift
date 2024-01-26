//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/26/24.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
