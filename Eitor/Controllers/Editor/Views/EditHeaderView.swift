//
//  EditHeaderView.swift
//  Eitor
//
//  Created by Mert Ozkaya on 25.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
//import ZImageCropper
//import RCStickerView


class EditHeaderView: UICollectionReusableView {
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trashView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "imageBackground")!)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.moveToTrash))
        self.trashView.addGestureRecognizer(gesture)
    }
        
    
    @IBAction func moveToTrash(_ sender: UIButton) {
            print("TRASH")
    }
}
