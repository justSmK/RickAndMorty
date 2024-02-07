//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/7/24.
//

import Foundation

struct RMLocationTableViewCellViewModel {
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
}
