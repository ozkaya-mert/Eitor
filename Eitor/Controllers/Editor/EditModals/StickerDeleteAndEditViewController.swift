//
//  StickerDeleteAndEditViewController.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import VisualEffectView
import Spring


extension StickerDeleteAndEditViewController: PhotoEditorDelegate {

    func doneEditing(image: UIImage) {
        self.image = image
    }

    func canceledEditing() {
        print("Canceled")
    }
    
    func closePage() {
        self.dismiss(animated: true, completion: nil)
    }
}


class StickerDeleteAndEditViewController: BaseViewController {

    @IBOutlet weak var visualEffectView: VisualEffectView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var springView: SpringView!
    
    var image: UIImage?
    var imageURL: String?
    
    var sticker_id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupEffectView(view: visualEffectView)
        
        editButton.setTitle(String.localize(word: "edit"), for: .normal)
        deleteButton.setTitle(String.localize(word: "delete"), for: .normal)
        cancelButton.setTitle(String.localize(word: "cancel"), for: .normal)
        showView()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        closeView { (_) in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func deleteSticker(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.deleteSticker()
        }
    }
    
    @IBAction func editSticker(_ sender: UIButton) {
        closeView { (_) in
            
            guard let photoEditor = UIStoryboard(name: "Edit", bundle: nil).instantiateViewController(withIdentifier: "EditorVC") as? EditorVC else {
                fatalError("EditorVC not found")
            }
            photoEditor.photoEditorDelegate = self
            
            photoEditor.originalImage = self.image
            photoEditor.mode = "fromDeleteAndUpdate"
            photoEditor.sticker_id = self.sticker_id
            photoEditor.colors = PhotoEditorColors.colors
            
            for i in 0...10 {
                photoEditor.stickers.append(UIImage(named: i.description )!)
            }
            photoEditor.hidesBottomBarWhenPushed = true
            let nc = BaseNavigationController(rootViewController: photoEditor)
            nc.modalPresentationStyle = .fullScreen
            nc.modalTransitionStyle = .coverVertical
            self.present(nc, animated: true, completion: nil)
            
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
        Helpers.delay(0.3) {
            self.springView.isHidden = true
            completion(true)
        }
    }
    
    
    func deleteSticker() {
    //        self.startIndicator()
        let params = [
            "sticker_id": String(self.sticker_id ?? 0),
        ]

        print(params)
//        Services.deleteSticker(params: params) { (response) in
//            guard let result = response else { return }
//            
//            print(result.message)
//            DispatchQueue.main.async {
//                if result.status != 200 {
//                    print("Sticker silme başarısız!!!")
//                }else {
//                    print("Sticker silme başarılı")
//                    self.myPackageInfoDelegate.deleteSticker()
//                }
////                self.stopIndicator()
//            }
//        }
    }
    
    
}
