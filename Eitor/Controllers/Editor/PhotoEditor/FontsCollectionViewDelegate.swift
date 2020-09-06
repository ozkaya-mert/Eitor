//
//  FontsCollectionViewDelegate.swift
//  Eitor
//
//  Created by Mert Ozkaya on 19.06.2020.
//  Copyright © 2020 app. All rights reserved.
//

import UIKit

extension EditorVC: FontDelegate {
    func didSelectFont(font: String) {
        registerFont(font: font)
        if isDrawing {
            self.textFont = font
        } else if activeTextView != nil {
            activeTextView?.font = UIFont(name: font, size: 20)
            textFont = font
        }
    }
}

class FontsCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var fontDelegate: FontDelegate?
    
    var fonts = UIFont.familyNames
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fonts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontTypeAndPatternCell", for: indexPath) as! FontTypeAndPatternCell
        cell.fontAndPatternLabel.text = "Abc"
        cell.fontAndPatternLabel.font = UIFont(name: fonts[indexPath.row], size: 16)
        cell.fontAndPatternLabel.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fontDelegate?.didSelectFont(font: fonts[indexPath.row])
        fontDelegate?.removeLastTextView(font: fonts[indexPath.row])
        print("didSelectItemAt:",fonts[indexPath.row])
    }

}
