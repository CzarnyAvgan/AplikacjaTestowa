//
//  User.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var surname: String
    var imageUrlString: String
    
    enum CodingKeys:String,CodingKey {
        case name = "first_name"
        case surname,imageUrlString
    }
}

struct Users: Codable {
    var users: [User]
}
