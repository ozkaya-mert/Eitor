//
//  ImageCropEditor.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.07.2020.
//  Copyright © 2020 app. All rights reserved.
//

import Foundation
import TOCropViewController

extension EditorVC: TOCropViewControllerDelegate{
    
    func presentCropViewController(image: UIImage) {
        print("Buradaaaa presentCropViewController")
        let cropController = TOCropViewController(croppingStyle: .default, image: image)
        cropController.aspectRatioPreset = .presetSquare
//        cropController.aspectRatioLockEnabled = true
//        cropController.aspectRatioPickerButtonHidden = true
//        cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 2848)
//        cropController.toolbar.resetButtonEnabled = false
//        cropController.toolbar.resetButtonHidden = true
        cropController.delegate = self
        cropController.customAspectRatioName = "asdfasdfsa"
        
        cropController.doneButtonTitle = "Tamam"
        cropController.cancelButtonTitle = "İptal"
        present(cropController, animated: true, completion: nil)
    }
        
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true){
            self.setImageView(image: image)
        }
    }
}
