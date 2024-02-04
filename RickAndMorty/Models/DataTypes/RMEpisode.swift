//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/17/24.
//

import Foundation

struct RMEpisode: Decodable, RMEpisodeDataRender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
