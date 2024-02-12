//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/12/24.
//

import Foundation

// Responsibilities
// - show search results
// - show no results view
// - kick off API requests

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
