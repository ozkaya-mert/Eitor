//
//  SpringAnimation.swift
//  Profil Analizi
//
//  Created by Mert Ozkaya on 12.08.2020.
//  Copyright © 2020 Profil Analizi. All rights reserved.
//

import Foundation
import UIKit
import Spring

enum SpringAnimation {
    case fadeIn, fadeOut, fadeInLeft, fadeInRight, slideRight, fadeInDown, fadeInUp, pop
    
    var animationType: String {
        switch self {
        case .fadeIn:
            return "fadeIn"
        case .fadeOut:
            return "fadeOut"
        case .fadeInLeft:
            return "fadeInLeft"
        case .fadeInRight:
            return "fadeInRight"
        case .slideRight:
            return "slideRight"
        case .fadeInDown:
            return "fadeInDown"
        case .fadeInUp:
            return "fadeInUp"
        case .pop:
            return "pop"
        
        }
    }
    
}
