//
//   Extensions.swift
//  RickAndMorty
//
//  Created by Sergei Semko on 1/19/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
