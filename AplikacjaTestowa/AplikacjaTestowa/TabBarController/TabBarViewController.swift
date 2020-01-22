//
//  TabBarViewController.swift
//  AplikacjaRekrutacyjna
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let optionsImages: [UIImage] = [#imageLiteral(resourceName: "user"),#imageLiteral(resourceName: "appInfo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        guard let tabBarItems = self.tabBar.items else { return }
        for (index,item) in tabBarItems.enumerated() {
            item.image = optionsImages[index]
        }
    }
}
