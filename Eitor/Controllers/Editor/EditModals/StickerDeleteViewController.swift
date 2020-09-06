//
//  PackageDeleteViewController.swift
//  Eitor
//
//  Created by Mert Ozkaya on 23.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import Spring
import VisualEffectView

class StickerDeleteViewController: BaseViewController {

    @IBOutlet weak var visualEffectView: VisualEffectView!
    @IBOutlet weak var deleteMessageLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var springView: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupEffectView(view: visualEffectView)
        
        deleteMessageLabel.text  = String.localize(word: "deletePacketMessage")
        deleteLabel.text = String.localize(word: "delete")
        deleteButton.setTitle(String.localize(word: "delete"), for: .normal)
        
        self.showView()
    }
    @IBAction func dismis(_ sender: UIButton) {
        self.dismiss(animated: true){
        }
    }
    
    @IBAction func deletePacket(_ sender: UIButton) {
        self.closeView { (_) in
            print("sildi")
        }
    }
    
    func showView(){
        springView.isHidden = true
        Helpers.delay(0.3) {
            self.springView.isHidden = false
            self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.5)
            
        }
    }
    
    func closeView(completion:@escaping(Bool) -> Void) {
        self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.5 ,out: true)
        Helpers.delay(0.5) {
            self.springView.isHidden = true
            completion(true)
        }
    }
    
}
