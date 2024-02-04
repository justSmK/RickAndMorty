//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/17/24.
//

import Foundation

struct RMLocation: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
