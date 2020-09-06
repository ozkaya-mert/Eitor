//
//  EraserSizeCell.swift
//  Eitor
//
//  Created by Mert Ozkaya on 23.06.2020.
//  Copyright © 2020 app. All rights reserved.
//

import UIKit

class EraserSizeCell: UICollectionViewCell {

    @IBOutlet weak var eraserSizeLabel: UILabel!
    @IBOutlet weak var eraserSizeSlider: UISlider!
    var mainDelegate: PhotoEditorMenuDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eraserSizeLabel.text = String.localize(word: "eraserSize")
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        mainDelegate?.changedEraserSize(eraserSize: sender.value)
    }
    
}


