//
//  RedoUndoView.swift
//  Eitor
//
//  Created by Mert Ozkaya on 25.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit

class RedoUndoView: UIView {

    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
}
