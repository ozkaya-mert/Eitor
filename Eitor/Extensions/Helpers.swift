//
//  Helpers.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

class Helpers: NSObject{
    class func openPermissionsSettings(){
       if let appSettings = URL(string: UIApplication.openSettingsURLString) {
           UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
       }
    }
    
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
}

