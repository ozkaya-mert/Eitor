//
//  ColorCollectionViewCell.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = colorView.frame.height / 2
        colorView.clipsToBounds = true
        colorView.layer.borderWidth = 1.0
        colorView.layer.borderColor = UIColor.white.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                
                colorView.borderColor = .white
                colorView.borderWidth = 2
//                let previouTransform =  colorView.transform
//                UIView.animate(withDuration: 0.2,
//                               animations: {
//                                self.colorView.transform = self.colorView.transform.scaledBy(x: 1.3, y: 1.3)
//                },
//                               completion: { _ in
//                                UIView.animate(withDuration: 0.2) {
//                                    self.colorView.transform  = previouTransform
//                                }
//                })
            } else {
                // animate deselection
            }
        }
    }
}
