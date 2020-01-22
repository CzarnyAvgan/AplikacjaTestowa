//
//  UserDetailsViewController.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            setupView(with: user)
        }
    }
    
    func setupView(with user: User) {
        nameLabel.text = user.name
        surnameLabel.text = user.surname
        
        let url = URL(string: user.imageUrlString)
        userImageView.sd_setImage(with: url, completed: nil)
    }
}
