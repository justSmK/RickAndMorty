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
    
    private var optionMap = [RMSearchInputViewViewModel.DynamicOption: String]()
    
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText) // .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            pathComponents: [],
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Decodable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            // Notify view of results, no results, or error
            switch result {
            case .success(let model):
                self?.processSearchResults(model)
            case .failure(let error):
                print("Failed to get results \(String(describing: error.localizedDescription))")
                // TODO: Add Logger
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(_ model: Decodable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap {
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            })
        } else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap {
                RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            })
        } else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap {
                RMLocationTableViewCellViewModel(location: $0)
            })
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        } else {
            // Fallback
            handleNoResults()
        }
        
    }
    
    private func handleNoResults() {
        noResultsHandler?()
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
}
