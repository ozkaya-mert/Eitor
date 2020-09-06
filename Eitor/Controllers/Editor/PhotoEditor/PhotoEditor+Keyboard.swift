//
//  PhotoEditor+Keyboard.swift
//  Eitor
//
//  Created by Mert Ozkaya on 23.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

extension EditorVC {
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if isTyping {
            doneButton.isHidden = false
            colorPickerView.isHidden = false
            self.mainMenuCollectionview.isHidden = true
            self.subMenuCollectionView.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isTyping = false
        doneButton.isHidden = true
        self.mainMenuCollectionview.isHidden = false
        self.subMenuCollectionView.isHidden = false
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.colorPickerViewBottomConstraint?.constant = 0.0
            } else {
                if let frameHeight = endFrame?.size.height {
                    self.colorPickerViewBottomConstraint?.constant = frameHeight
                    print(frameHeight)
                }else {
                    self.colorPickerViewBottomConstraint?.constant = 0.0
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}
