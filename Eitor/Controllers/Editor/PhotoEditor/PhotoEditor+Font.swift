//
//  PhotoEditor+Font.swift
//  Eitor
//
//  Created by Mert Ozkaya on 27.07.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

extension EditorVC {
    
    //Resources don't load in main bundle we have to register the font
    func registerFont(font: String) {
            if let uiFont = UIFont(name: font, size: 36.0),
            let cgFont = CGFont(uiFont.fontName as CFString) {
                var error: Unmanaged<CFError>?
                guard CTFontManagerRegisterGraphicsFont(cgFont, &error) else {
                    return
                }
            }
    }
}
