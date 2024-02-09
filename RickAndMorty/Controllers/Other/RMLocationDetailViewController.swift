//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 2/9/24.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {
    
    private let viewModel: RMLocationDetailViewViewModel
    
    private let detailView = RMLocationDetailView()
    
    // MARK: - Init

    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        addConstraints()
        title = "Location"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapShare() {
        
    }
}

// MARK: - RMLocationDetailViewViewModelDelegate

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

// MARK: - RMLocationDetailViewDelegate

extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
