//
//  LastEditProcesses.swift
//  Eitor
//
//  Created by Mert Ozkaya on 25.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

final class LastEditProcesses {
    var type: Control
    var drawing: DrawingModel? = nil
    var cropPoints: [CGPoint]? = nil
    var image: UIImage? = nil
    
    init(type: Control, drawing: DrawingModel?) {
        self.type = type
        self.drawing = drawing
    }
    
    init(type:Control, cropPoints: [CGPoint]) {
        self.type = type
        self.cropPoints = cropPoints
    }
    
    init(type:Control, image: UIImage?) {
        self.type = type
        self.image = image
    }
    
}
