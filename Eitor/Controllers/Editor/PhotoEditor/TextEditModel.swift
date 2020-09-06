//
//  TextEditModel.swift
//  Eitor
//
//  Created by Mert Ozkaya on 29.06.2020.
//  Copyright © 2020 app. All rights reserved.
//

import Foundation
import UIKit

class TextEditModel {
    
    var textView: UITextView?
    var type: String
    
    init(textView: UITextView, type: String) {
        self.textView = textView
        self.type = type
    }
    
}
