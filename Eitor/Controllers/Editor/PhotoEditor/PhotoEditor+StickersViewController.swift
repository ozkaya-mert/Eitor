//
//  PhotoEditor+StickersViewController.swift
//  Eitor
//
//  Created by Mert Ozkaya on 23.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

extension EditorVC {
    
    func addStickersViewController() {
        stickersVCIsVisible = true
//        hideToolbar(hide: true)
        self.canvasImageView.isUserInteractionEnabled = false
        stickersViewController.stickersViewControllerDelegate = self
        
        for image in self.stickers {
            stickersViewController.stickers.append(image)
        }
        self.addChild(stickersViewController)
        self.view.addSubview(stickersViewController.view)
        stickersViewController.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        stickersViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeStickersView() {
        stickersVCIsVisible = false
        self.canvasImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.stickersViewController.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.stickersViewController.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.stickersViewController.view.removeFromSuperview()
            self.stickersViewController.removeFromParent()
//            self.hideToolbar(hide: false)
        })
    }    
}

extension EditorVC: StickersViewControllerDelegate {
    
    func didSelectView(view: UIView) {
        self.removeStickersView()
        
        view.center = canvasImageView.center
        self.canvasImageView.addSubview(view)
        //Gestures
        addGestures(view: view)
    }
    
    func didSelectImage(image: UIImage) {
        self.removeStickersView()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 150, height: 150)
        imageView.center = canvasImageView.center
        
        self.canvasImageView.addSubview(imageView)
        //Gestures
        addGestures(view: imageView)
    }
    
    func stickersViewDidDisappear() {
        stickersVCIsVisible = false
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(EditorVC.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(EditorVC.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(EditorVC.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditorVC.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
}
