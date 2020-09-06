//
//  MyButton.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {

    func setText(text: String, font: UIFont) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
    }
    
    func setColor(textColor: UIColor, backgroundColor: UIColor) {
        self.titleLabel?.textColor = textColor
        self.backgroundColor = textColor
        self.clipsToBounds = true
        self.cornerRadius = self.frame.height / 2
    }
    
}
