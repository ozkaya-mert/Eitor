//
//  BaseViewController.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import Spring
import VisualEffectView

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func titleLabel(_ title: String, _ color:UIColor,_ font: UIFont = .systemFont(ofSize: 16)) -> UILabel {
        let label  = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
    
    func showSpringAnimation(view:SpringView,type:SpringAnimation,duration: CGFloat = 0.7,out:Bool = false)  {
        view.animation = type.animationType
        view.duration  = duration
        if out {
            view.animateTo()
            
        }else{
            view.animate()
        }
    }
    
    func setupLeftNavigationBarButton() {
        let leftMenuItem = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(popToBeforeScene(_:)))
        self.navigationItem.setLeftBarButton(leftMenuItem, animated: false)
    }
    
    @objc private func popToBeforeScene(_ bar: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupEffectView(view: VisualEffectView, blurColor: UIColor = UIColor.black.withAlphaComponent(0.5)) {
        view.colorTintAlpha = 0.7
        view.colorTint      = blurColor
        view.blurRadius     = 5
        view.scale          = 1
    }

}
