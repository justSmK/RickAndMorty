//
//  RMTabBarViewController.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/17/24.
//

import UIKit

/// Controller to house tabs and root tab controllers
// TODO: Use UIPageVC with UITabBarView instead UITabBarVC
final class RMTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        setUpSwipeGestures()
    }

    private func setUpTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let navCharacterVC = UINavigationController(rootViewController: characterVC)
        let navLocationVC = UINavigationController(rootViewController: locationVC)
        let navEpisodeVC = UINavigationController(rootViewController: episodeVC)
        let navSettingsVC = UINavigationController(rootViewController: settingsVC)
        
        navCharacterVC.tabBarItem = UITabBarItem(title: "Characters",
                                                 image: UIImage(systemName: "person"),
                                                 tag: 1)
        navLocationVC.tabBarItem = UITabBarItem(title: "Locations",
                                                image: UIImage(systemName: "globe"),
                                                tag: 2)
        navEpisodeVC.tabBarItem = UITabBarItem(title: "Episodes",
                                               image: UIImage(systemName: "tv"),
                                               tag: 3)
        navSettingsVC.tabBarItem = UITabBarItem(title: "Settings",
                                                image: UIImage(systemName: "gear"),
                                                tag: 4)
        
        let navControllers = [
            navCharacterVC,
            navLocationVC,
            navEpisodeVC,
            navSettingsVC
        ]
        
        for nav in navControllers {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(navControllers, animated: true)
    }
}

// MARK: - UISwipeGestureRecognizer Navigation

private extension RMTabBarViewController {
    
    func setUpSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc
    private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if selectedIndex < (viewControllers?.count ?? 1) - 1 {
                selectedIndex += 1
            }
        } else if sender.direction == .right {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
    }
}
