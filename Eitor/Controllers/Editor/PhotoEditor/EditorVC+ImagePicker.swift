//
//  EditorVC+ImagePicker.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit

extension EditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                imagePickerController.cameraDevice = .front
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func openGallery() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = false
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("girdii")
        if let originalImage = info[.originalImage] as? UIImage {
            self.setImageView(image: originalImage)
            self.tempImage = originalImage
            self.originalImage = originalImage
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
