//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/17/24.
//

import Foundation

struct RMCharacter: Decodable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}


