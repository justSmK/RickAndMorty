//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/18/24.
//

import Foundation

enum RMCharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
