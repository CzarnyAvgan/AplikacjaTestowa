//
//  UITextField+Padding.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import Foundation
import  UIKit

extension UITextField {
     func setLeftPaddingPoints(_ value: CGFloat){
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
         self.leftView = paddingView
         self.leftViewMode = .always
     }
}
