//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/20/24.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
