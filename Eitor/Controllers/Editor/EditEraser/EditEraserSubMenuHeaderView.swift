//
//  EditEraserSubMenuHeaderView.swift
//  Eitor
//
//  Created by Mert Ozkaya on 23.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit

class EditEraserSubMenuHeaderView: UICollectionReusableView {

    @IBOutlet weak var editSubMenuHeaderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editSubMenuHeaderLabel.text = String.localize(word: "eraseBackground")
    }
    
}
