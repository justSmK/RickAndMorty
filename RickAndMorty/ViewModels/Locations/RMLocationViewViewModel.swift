//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/7/24.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = []
    
    private func addViewModel(location: RMLocation) {
        let viewModel = RMLocationTableViewCellViewModel(location: location)
        cellViewModels.append(viewModel)
    }
    
    // Location response info
    // Will contain next url, if present
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    init() {}
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(
            .listLocationsRequest,
            expecting: RMGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                
                for result in model.results {
                    self?.addViewModel(location: result)
                }
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure:
                break
            }
        }
    }
    
    private var hasMoreResult: Bool {
        return false
    }
}
