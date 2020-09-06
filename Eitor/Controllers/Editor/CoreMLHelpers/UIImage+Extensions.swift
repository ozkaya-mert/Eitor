//
//  UIImage+Extensions.swift
//  Eitor
//
//  Created by Mert Ozkaya on 27.07.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UIImage {
  /**
    Resizes the image.

    - Parameters:
      - scale: If this is 1, `newSize` is the size in pixels.
  */
  @nonobjc public func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
    let format = UIGraphicsImageRendererFormat.default()
    format.scale = scale
    let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
    let originalImage = renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
    return originalImage
  }
}

#endif
