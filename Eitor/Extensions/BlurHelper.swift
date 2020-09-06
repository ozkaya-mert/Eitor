//
//  BlurHelper.swift
//  Eitor
//
//  Created by Mert Ozkaya on 29.06.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import VisualEffectView

final class BlurHelper {
    class func setup(view: VisualEffectView, blurColor: UIColor = UIColor.black.withAlphaComponent(0.5)) {
        view.colorTintAlpha = 0.7
        view.colorTint      = blurColor
        view.blurRadius     = 5
        view.scale          = 1
    }
}
