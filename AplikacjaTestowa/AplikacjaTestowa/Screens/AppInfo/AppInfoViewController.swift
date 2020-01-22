//
//  AppInfoViewController.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import UIKit
import SDWebImage

class AppInfoViewController: UIViewController {

    @IBOutlet weak var clicableLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClicableLabel()
        setupCustomImage()
    }
    
    private func setupClicableLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        clicableLabel.isUserInteractionEnabled = true
        clicableLabel.addGestureRecognizer(tap)
    }
    
    @objc private func labelTapped() {
        let linkString = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        if let url = URL(string: linkString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setupCustomImage() {
        let linkString = "https://assets.fireside.fm/file/fireside-images/podcasts/images/b/bc7f1faf-8aad-4135-bb12-83a8af679756/cover_medium.jpg"
        let url = URL(string: linkString)
        customImageView.sd_setImage(with: url, completed: nil)
    }

}
