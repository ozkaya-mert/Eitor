//
//  MainEditOptionCell.swift
//  Eitor
//
//  Created by Mert Ozkaya on 25.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit

class EditMenuOptionCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel.textColor = UIColor(hexString: "FFFFFFF")
    }
    
    func setupUI(text: String, image: UIImage) {
        titleLabel.text = text
        iconImageView.image = image
        iconImageView.tintColor = .white

    }


    
}
