//
//  UIView+Image.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)

        // Get that context
        let context = UIGraphicsGetCurrentContext()

        // Draw the image view in the context
        self.layer.render(in: context!)

        // You may or may not need to repeat the above with the imageView's subviews
        // Then you grab the "screenshot" of the context
        let image = UIGraphicsGetImageFromCurrentImageContext()

        // Be sure to end the context
        UIGraphicsEndImageContext()

        return image!
    }
    
    
    func mySnapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view

        UIGraphicsBeginImageContextWithOptions(bounds.size,  false, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // if no `rect` provided, return image of whole view
        print("zzzzz    ")
        guard let image = wholeImage, let rect = rect else { return wholeImage }

        return nil
    }
    
}
