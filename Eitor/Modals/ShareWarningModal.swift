//
//  ShareWarningModal.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import Spring
import VisualEffectView

class ShareWarningModal: BaseViewController {

    @IBOutlet weak var visualEffectView: VisualEffectView!
    @IBOutlet weak var springView: SpringView!
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var warningIcon: UIImageView!
    
    var warningDesc: String?
    var warningTitle: String?
    var warningType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        BlurHelper.setup(view: visualEffectView,blurColor: UIColor.gray.withAlphaComponent(0.5))
        view.backgroundColor = .clear
        
        if let warningTitle = self.warningTitle {
            titleLabel.text = warningTitle
        }
        
        
//        if let warningDescription = warningDesc {
//            descriptionLabel.text = warningDescription
//        }
        
        switch warningType {
        case "warning":
            self.warningIcon.image = UIImage(named: "warning")
        case "error":
            self.warningIcon.image = UIImage(named: "error")
        case "success":
            self.warningIcon.image = UIImage(named: "success")
        default:
            break
        }
        
        closeButton.setTitle(String.localize(word: "close"), for: .normal)
        closeButton.isHidden = false
    }
    
    fileprivate func showView(){
        springView.isHidden = true
        Helpers.delay(0.3) {
            self.springView.isHidden = false
            self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.5)
        }
    }
    @IBAction func close(_ sender: UIButton) {
        closeView { (_) in
            self.dismiss(animated: true)
        }
    }
    
    fileprivate func closeView(completion:@escaping(Bool) -> Void) {
        self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.3 ,out: true)
        Helpers.delay(0.5) {
            self.springView.isHidden = true
            completion(true)
        }
    }
}
