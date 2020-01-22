//
//  UserTableViewCell.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var personalDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    private func setupShadow() {
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.masksToBounds = false
        bgView.layer.shadowRadius = 10.0
        bgView.layer.cornerRadius = 10.0
        
        self.clipsToBounds = true
    }
    
    func setupCell(_ user: User) {
        personalDataLabel.text = "\(user.name) \(user.surname)"
    }
    
}
