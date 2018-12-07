//
//  ViewController.swift
//  CSC470Euler
//
//  Created by Jozeee on 10/13/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

/// The parent/superclass view controller in case we want custom changes across several view controllers
/// at the same time.
class ParentViewController: UIViewController {
    
    var backgroundImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    private func setupBackground() {
        guard let image = UIImage(named: "Background") else { return }
        backgroundImage = UIImageView(image: image)
        backgroundImage?.contentMode = UIView.ContentMode.scaleAspectFill
        if let bgImageView = backgroundImage {
            view.addSubview(bgImageView)
            bgImageView.translatesAutoresizingMaskIntoConstraints = false
            bgImageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
            bgImageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
            bgImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
            bgImageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            view.sendSubviewToBack(bgImageView)
        }
    }
}
