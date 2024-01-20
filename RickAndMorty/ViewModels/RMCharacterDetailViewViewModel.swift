//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/20/24.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
