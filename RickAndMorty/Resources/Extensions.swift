//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/19/24.
//

import UIKit
import OSLog

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the URLCache
    static let cache = Logger(subsystem: subsystem, category: "cache")
}
