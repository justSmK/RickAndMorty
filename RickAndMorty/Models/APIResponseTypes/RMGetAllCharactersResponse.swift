//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/19/24.
//

import Foundation

struct RMGetAllCharactersResponse: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
