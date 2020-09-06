//
//  PhotoEditor+Controls.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//


import Foundation
import UIKit

// MARK: - Control
public enum Control {
    case manualCrop
    case quadraticCrop
    case draw
    case text
    case clearDraw
    case magicEraser
    case eraser
    case none
}

extension EditorVC {
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneTapped()
    }
    
    func doneTapped() {
        view.endEditing(true)
        doneButton.isHidden = true
        self.navigationItem.titleView = nil
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        cartoonURL = nil
        isDrawing = false
        setupRightNavigationItem()
        control = .none
        self.canvasImageView.isHidden = false
        if isEraser {
            isEraser = false
            self.canvasImageView.isHidden = false
            self.selectedSubmenuIndex = nil
            self.activeEraserEditIndex = nil
//            guard let gestureRecognizers = canvasImageView.subviews[0].gestureRecognizers else{
//                return
//            }
//            gestureRecognizers[0].isEnabled = true

            self.subMenuCollectionView.reloadData()
        }
        self.subMenuCollectionView.reloadData()

    }
    
}
