//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/27/24.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI (table or collection as needed)
final class RMSearchResultsView: UIView {
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RMLocationTableViewCell.self,
                       forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    private var collectionViewCellViewModels: [Any] = []
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(tableView, collectionView)
        addConstraints()
    }
    
//    #warning("To do that everywhere")
    // TODO: add this code everywhere
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func processViewModel() {
        guard let viewModel else {
            return
        }
        switch viewModel {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
            
        }
    }
    
    private func setUpCollectionView() {
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Public

    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        let viewModel = locationCellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.item]
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            // Character cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: characterVM)
            return cell
        }
        
        // Episode
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Handle cell tap
    }
    
    // TODO: Fix size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.item]
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            // Character size
            let bounds = UIScreen.main.bounds
    //        let bounds = collectionView.window?.windowScene?.screen.bounds
            let width = (bounds.width - 30) / 2
            return CGSize(
                width: width,
                height: width * 1.5
            )
        }
        
        // Episode
        let bounds = collectionView.bounds
//        let bounds = collectionView.window?.windowScene?.screen.bounds
        let width = bounds.width - 20
        return CGSize(
            width: width,
            height: 100
        )
    }
}