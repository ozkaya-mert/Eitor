//
//  RedoView.swift
//  Eitor
//
//  Created by Mert Ozkaya on 25.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit

class RedoView: UIView {

    @IBOutlet weak var redoButton: UIButton!
    override init(frame: CGRect) {
      super.init(frame: frame)
    } 
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

}
