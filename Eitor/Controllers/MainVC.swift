//
//  MainVC.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import TOCropViewController

class MainVC: BaseViewController, TOCropViewControllerDelegate {

    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitle.text = String.localize(word: "mainTitle")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "EITOR"
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.isTranslucent = false
//    }

    @IBAction func openCamera(_ sender: UIButton) {
        PermissionsHelpers.showCameraPermissions { (res) in
            if res {
                self.openCamera()
            }else {
                print("showCameraPermissions false")
                let alert = UIAlertController(title: "Uyarı", message: "Kamerayı kullanabilmek için izin vermelisiniz", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    Helpers.openPermissionsSettings()
                }))
                alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: { action in

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        PermissionsHelpers.checkPhotoLibraryPermission { (response) in
            if response {
                self.openGallery()  
            }else {
                print("showGalleryPermissions false")
                let alert = UIAlertController(title: "Uyarı", message: "Galeriden fotoğraf seçebilmek için izin vermelisiniz", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    Helpers.openPermissionsSettings()
                }))
                alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: { action in

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func presentCropViewController(image: UIImage) {
        print("Buradaaaa presentCropViewController")
        let cropController = TOCropViewController(croppingStyle: .default, image: image)
        cropController.aspectRatioPreset = .presetSquare
        cropController.aspectRatioLockEnabled = true
        cropController.aspectRatioPickerButtonHidden = true
        cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 2848)
        cropController.toolbar.resetButtonEnabled = false
        cropController.toolbar.resetButtonHidden = true
        cropController.delegate = self

        present(cropController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true){
            
//            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditorVC") as? EditorVC {
//                viewController.image = image
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
        }
    }

    
    
    
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    private func openCamera() {
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
    
    private func openGallery() {
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
        
        self.dismiss(animated: true) {
                print("girdii")
                if let originalImage = info[.originalImage] as? UIImage {
//                    self.presentCropViewController(image: originalImage)
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditorVC") as? EditorVC {
                        viewController.originalImage = originalImage
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
