//
//  RMCharacterGender.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/18/24.
//

import Foundation

enum RMCharacterGender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case `unknown` = "unknown"
}
