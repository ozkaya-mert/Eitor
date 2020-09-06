//
//  EditMenuCollectionCell.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditMenuCollectionCell: UICollectionViewCell {

    let TAG: String = "EditMenuCollectionCell"

    var photographTitles = [String.localize(word: "camera"), String.localize(word: "gallery"), String.localize(word: "selectSticker")]
    var photographImages = [UIImage(named: "editCamera"), UIImage(named: "gallery"),UIImage(named: "selectStickerIcon")]
    
    let unclickImages = [UIImage(named: "unclick-image-line"),UIImage(named: "unclick-eraser-line") ,UIImage(named: "unclick-text"), UIImage(named: "unclick-brush-line")]
    
    let clickImages = ["click-image-line", "click-eraser-line","click-text", "click-brush-line"]
    let eraserSubMenu = [ String.localize(word: "quickEraser"), String.localize(word: "eraser"), String.localize(word: "reset")]

    //TODO
    var textPatterns = [String]()
    
    var fonts = UIFont.familyNames
    var imageView = UIImageView()
    @IBOutlet weak var collectionView: UICollectionView!
    weak var menuDelegate: PhotoEditorMenuDelegate?
    var selectedIndex = 0
    var cellCount: Int?
    var activeTextEditIndex = 0
    var activeEraserIndex: Int?
    var eraserSize:Float = 2.0
    
    //TODO-This
    var cartoonEffects = [Cartoon]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ indexPathRow: Int) {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let photographNib = UINib(nibName: "PhotographEditCell", bundle: nil)
        collectionView.register(photographNib, forCellWithReuseIdentifier: "PhotographEditCell")
        
        let eraserSubMenuHeaderNib = UINib(nibName: "EditEraserSubMenuHeaderCell", bundle: nil)
        collectionView.register(eraserSubMenuHeaderNib, forCellWithReuseIdentifier: "EditEraserSubMenuHeaderCell")
        
        let eraserSubMenuNib = UINib(nibName: "EditEraserSubMenuCell", bundle: nil)
        collectionView.register(eraserSubMenuNib, forCellWithReuseIdentifier: "EditEraserSubMenuCell")
        
        let eraserSizeNib = UINib(nibName: "EraserSizeCell", bundle: nil)
        collectionView.register(eraserSizeNib, forCellWithReuseIdentifier: "EraserSizeCell")
        
        let textEditSubMenuNib = UINib(nibName: "TextEditSubMenuCell", bundle: nil)
        collectionView.register(textEditSubMenuNib, forCellWithReuseIdentifier: "TextEditSubMenuCell")
        
        let fontPatternNib = UINib(nibName: "FontTypeAndPatternCell", bundle: nil)
        collectionView.register(fontPatternNib, forCellWithReuseIdentifier: "FontTypeAndPatternCell")
        
        let cartoonEffectNib = UINib(nibName: "CartoonEffectCell", bundle: nil)
        collectionView.register(cartoonEffectNib, forCellWithReuseIdentifier: "CartoonEffectCell")
        
        self.cellCount = indexPathRow
        self.collectionView.reloadData()
    }
    
}

extension EditMenuCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return photographImages.count
        }else if selectedIndex == 1 {
            if cellCount == 0 {
                return 1
            }else {
                return eraserSubMenu.count
            }
        }else if selectedIndex == 2{
            if cellCount == 0 {
                return 2
            }else {
                print("asdasd")
                if activeTextEditIndex == 0 {
                    print("5")
                    return textPatterns.count
                }else {
                    print("3")
                    return fonts.count
                }
            }
        }else {
            return cartoonEffects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotographEditCell", for: indexPath) as! PhotographEditCell
           cell.imageView.image = photographImages[indexPath.row]
           cell.titleLabel.text = photographTitles[indexPath.row]
           return cell
        }else if selectedIndex == 1{ // selectedIndex == 1
            if cellCount == 0 { // Erase Background or Eraser Size cell
                if activeEraserIndex == 1 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EraserSizeCell", for: indexPath) as! EraserSizeCell
                    cell.eraserSizeSlider.value = eraserSize
                    cell.mainDelegate = menuDelegate
                    return cell
                }else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditEraserSubMenuHeaderCell", for: indexPath) as!
                    EditEraserSubMenuHeaderCell
                    return cell
                }
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditEraserSubMenuCell", for: indexPath) as! EditEraserSubMenuCell
                cell.subMenuTitle.text = eraserSubMenu[indexPath.row]
                cell.borderWidth = 1
                cell.borderColor = UIColor(hexString:"979797")
                cell.cornerRadius = cell.frame.size.height / 2
                return cell
            }
        }else if selectedIndex == 2{ //text Editing
            if cellCount == 0 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextEditSubMenuCell", for: indexPath) as! TextEditSubMenuCell
//                cell.setupUI()
                if indexPath.row == activeTextEditIndex {
                    cell.textEditLabel.backgroundColor = UIColor(hexString: "000000")
                    cell.textEditLabel.textColor = .white
                }else {
                    cell.textEditLabel.backgroundColor = UIColor(hexString:"F7F7F7")
                    cell.textEditLabel.textColor = UIColor(hexString:"C3C3C3")
                }
                
                if indexPath.row == 0 {
                    cell.textEditLabel.text = String.localize(word: "textPatterns")
                }else {
                    cell.textEditLabel.text = String.localize(word: "fontType")
                }
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontTypeAndPatternCell", for: indexPath) as! FontTypeAndPatternCell
                cell.fontAndPatternLabel.cornerRadius = cell.frame.height / 2
                if activeTextEditIndex == 0 {
                    //TODO-This
//                    cell.fontAndPatternLabel.text = textPatterns[indexPath.row].ready_text
                    cell.fontAndPatternLabel.font = UIFont(name: "Muli", size: 14)
                }else {
                    cell.fontAndPatternLabel.text = "Abc"
                    cell.fontAndPatternLabel.font = UIFont(name: fonts[indexPath.row], size: 16)
                }
                return cell
            }
        }else { //selectedIndex==3, cartoon effect
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartoonEffectCell", for: indexPath) as! CartoonEffectCell
            //TODO-This
//            cell.imageView.setImage_SD(cartoonEffects[indexPath.row].url)
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("EDitMEnuCollectionCell didSelect")
        if selectedIndex == 0 {
            if indexPath.row == 0 {
                menuDelegate?.getImage(fromSourceType: .camera)
            }else if indexPath.row == 1 {
                menuDelegate?.getImage()
            }else {
                menuDelegate?.addSticker()
                
            }
        }else if selectedIndex == 1 {
            if cellCount == 1 && indexPath.row == 0{
                print("magic eraser tıklandı")
                guard let delegate = self.menuDelegate else {
                    return
                }
                
                delegate.startAnimationWithSV()
                
                if #available(iOS 12.0, *) {
                    delegate.magicEraser()
                }else {
                    SVProgressHUD.dismiss()
                    delegate.magicEraserAlert()
                    print("Bu özellik ios 12 sürüm ve sonrasında kullanılabilir")
                }
                
                
            }else if cellCount == 1 && indexPath.row == 1 {
                menuDelegate?.manualEraser()
            }else if cellCount == 1 && indexPath.row == 2 {
                menuDelegate?.resetImageView()
            }
            activeEraserIndex = indexPath.row
            menuDelegate?.didSelectSubMenu(activeTextEditIndex: self.activeTextEditIndex, activeEraserEditIndex: self.activeEraserIndex)
        }else if selectedIndex == 2 {
            
            if cellCount == 0 && indexPath.row == 0 {
                activeTextEditIndex = indexPath.row
            }else if cellCount == 0 && indexPath.row == 1{
                activeTextEditIndex = indexPath.row
            }else if cellCount == 1 && activeTextEditIndex == 0 {
                //TODO-This
//                menuDelegate?.addTextPattern(text: textPatterns[indexPath.row].ready_text)
            }else if cellCount == 1 && activeTextEditIndex == 1 {
                menuDelegate!.clickedToTextEdit(text: "", font: fonts[indexPath.row])
            }
            
            menuDelegate?.didSelectSubMenu(activeTextEditIndex: self.activeTextEditIndex, activeEraserEditIndex: self.activeEraserIndex)
        }else {
            //TODO-This
//            menuDelegate?.didSelectCartoonEffect(style_id: cartoonEffects[indexPath.row].id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndex == 0 {
            return CGSize(width: (collectionView.frame.width - 60)/3, height: 84)
        
        }
        // ************************************ //
        // ERASER EDIT
        // ************************************ //
        else if selectedIndex == 1{
            if cellCount == 0 {
                return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.size.height)
            }else {
                var currentSize = eraserSubMenu[indexPath.row].size(withAttributes: [
                                   NSAttributedString.Key.font: UIFont(name: "Muli-Bold", size: 14)!
                               ])
                
                currentSize.width = currentSize.width + 56 + 40
                return CGSize(width: currentSize.width, height: collectionView.frame.size.height)

            }
            
        // ************************************ //
        // TEXT EDIT
        // ************************************ //
        }else if selectedIndex == 2{
            if cellCount == 0 { // Yazı ana menusunun alt menusu gosteriliyorsa
                var currentSize = CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
                if indexPath.row == 0 { //
                    currentSize = String.localize(word: "textPatterns").size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Muli", size: 16)!])
                    currentSize.width = currentSize.width + 20
                    return CGSize(width: currentSize.width, height: 50)
                }else {
                    return CGSize(width: collectionView.frame.size.width - currentSize.width - 40, height: 50)
                }
            }else {
                if activeTextEditIndex == 0 {
                    //TODO-This
//                    var currentSize = textPatterns[indexPath.row].ready_text.size(withAttributes: [
//                        NSAttributedString.Key.font: UIFont(name: "Muli-Bold", size: 14)!
//                    ])
//                    currentSize.width = currentSize.width + 20
//                    return CGSize(width: currentSize.width, height: 50)
                    return CGSize(width: 100, height: 50)
                }else {
                    return CGSize(width: 100, height: 50)
                }
            }
            
        }
        // ************************************ //
        else {
            return CGSize(width: (collectionView.frame.width - 60)/3, height: 84)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if selectedIndex == 0 || selectedIndex == 3 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }else if selectedIndex == 1 {
            if cellCount == 0 {
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            }else {
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            }
        }else if selectedIndex == 2 {
            if cellCount == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }else {
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if selectedIndex == 0 {
            return 10
        }else if selectedIndex == 1 {
            return 10
        }else if selectedIndex == 2 {
            print("EditMenuCollectionCell minimumInteritemSpacingForSectionAt selectecIndex=2")
            return 10
        }else if selectedIndex == 3 {
            return 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if selectedIndex == 2 {
            if cellCount == 1 {
                if activeTextEditIndex == 0 {
                    return 10
                }else {
                    return 10
                }
            }else {
                return 10
            }
        }else {
            return 10
        }
    }
    
}





