//
//  PhotoEditor+MainDelegate.swift
//  Eitor
//
//  Created by Mert Ozkaya on 14.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit
import VisualEffectView
import SVProgressHUD

protocol PhotoEditorMenuDelegate: class {
    func clickedToTextEdit(text: String, font: String)
    func magicEraser()
    func didSelectMainMenu(indexPathRow: Int)
    func clearAll()
    func addTextPattern(text: String)
    func manualEraser()
    func didSelectSubMenu(activeTextEditIndex:Int, activeEraserEditIndex:Int?)
    func changedEraserSize(eraserSize: Float)
    func getImage()
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType)
    func setImageFromGallery(image: UIImage)
    func quadraticCrop(image: UIImage)
    func addSticker()
    func didSelectCartoonEffect(style_id: String)
    func resetImageView()
    func startAnimationWithSV()
    func stopAnimation()
    func magicEraserAlert()
    func manualCropImage(ofImageView:UIImageView, withinPoints points:[CGPoint]) -> UIImage?
}

extension EditorVC{
    func magicEraserAlert() {
        
        print("Magic eraser kullanılamaz")
        let controller = UIStoryboard(name: "PackageManagement", bundle: nil).instantiateViewController(withIdentifier: "ShareWarningModal") as! ShareWarningModal
        controller.warningTitle = "Uyarı"
        controller.warningDesc = String.localize(word: "magicEraserAlert")
        controller.warningType = "warning"
        
        let nav = BaseNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle   = .crossDissolve
        present(nav, animated: true, completion: nil)
    }
    
    public func clickedToTextEdit(text: String, font: String) {
        self.canvasImageView.isHidden = false
        textFont = font
        print("clickedToTextEdit")
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                             width: UIScreen.main.bounds.width, height: 50))
        textView.textAlignment = .center
        textView.font = UIFont(name: textFont, size: 22)
        textView.tag = textViewTag
        textViewTag += 1
        textView.textColor = textColor
        textView.text = text
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.textModels.append(TextEditModel(textView: textView, type: "text"))
        
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
     }
    
    public func addTextPattern(text: String){
        self.canvasImageView.isHidden = false

        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 50))
        textView.textAlignment = .center
        textView.font = UIFont(name: textFont, size: 20)
        textView.text = text
        textView.isEditable = false
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
//        textView.delegate = self
        textView.isSelectable = false
        self.textModels.append(TextEditModel(textView: textView, type: "textPattern"))
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)

    }
    public func magicEraser() {

            guard let image = self.showImageView.image else {
                print("magicEraser() imageView.image not found")
                SVProgressHUD.dismiss()
                return
            }


            if #available(iOS 12.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            
                    let removeBackObj = BackgroundRemoval()
                    guard let removedBackImage = removeBackObj.removeBackground(image: image) else {
                        SVProgressHUD.dismiss()

                        let controller = UIStoryboard(name: "PackageManagement", bundle: nil).instantiateViewController(withIdentifier: "ShareWarningModal") as! ShareWarningModal
                        
                        controller.warningTitle = "Hata"
                        controller.warningDesc = "Arka plan kaldırılırken bir hata oluştu. Lütfen tekrar deneyin."
                        controller.warningType = "error"

                        let nav = BaseNavigationController(rootViewController: controller)
                        nav.modalPresentationStyle = .overFullScreen
                        nav.modalTransitionStyle   = .crossDissolve
                        self.present(nav, animated: true, completion: nil)
                        return
                    }


                    
                    print("removed Image:", removedBackImage)
                    self.showImageView.image = removedBackImage
                    self.lastEdits.append(LastEditProcesses(type: .magicEraser, image: removedBackImage))
                    self.tempImage = removedBackImage
                    SVProgressHUD.dismiss()
                }
            }else {
                print("Magic eraser kullanılamaz")
                SVProgressHUD.dismiss()
                magicEraserAlert()
            }
        
    }
    
    public func didSelectMainMenu(indexPathRow: Int) {
        self.selectedIndexPathRow = indexPathRow
        
        self.subMenuCollectionView.reloadData()
    }
    
    public func clearAll() {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func resetImageView() {
        if let image = self.originalImage {
            setImageView(image: image)
        }
        
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
        
        self.removedDrawLines.removeAll()
        self.removedClearLines.removeAll()
        indexDraw = 0
        indexClearDraw = 0
        drawColor = .red
        isSwiped = false
    }
    
    public func removeLastTextView(font: String) {
        let lastText:String = (textModels[textModels.count - 1].textView?.text)!
        self.textFont = font

//        //clear drawing
//        canvasImageView.image = nil
//        //clear stickers and textviews
//        for subview in canvasImageView.subviews {
//            subview.removeFromSuperview()
//        }
        
        for subview in canvasImageView.subviews {
            if subview is UITextView {
                print("TextView!!!")
                subview.removeFromSuperview()
            }else {
                print("TextView Değil") 
            }
        }
        
        
        let _ = textModels.popLast()
//        textModels[textModels.count - 1].textView?.font = UIFont(name: font, size: 22)
        for item in textModels {
            self.canvasImageView.addSubview(item.textView!)
        }
        
        self.clickedToTextEdit(text: lastText, font: font)
    }
    
    public func manualEraser() {
        doneButton.isHidden = false
        self.canvasImageView.isHidden = true
        isEraser = true
        self.navigationItem.setRightBarButton(nil, animated: false)

        let redoUndoView = Bundle.main.loadNibNamed("RedoUndoView", owner: nil, options: nil)?[0] as! RedoUndoView
        redoUndoView.undoButton.addTarget(self, action: #selector(geri(_:)), for: .touchUpInside)
        redoUndoView.redoButton.addTarget(self, action: #selector(ileri(_:)), for: .touchUpInside)
        redoUndoView.stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        navigationItem.titleView = redoUndoView

//        let btn = UIBarButtonItem(customView: view)
//        navigationItem.rightBarButtonItem = btn
//        view.shadowView.layer.cornerRadius = 9
//        view.coin.text = coin
    }
    
    func draw() {
        doneButton.isHidden = false
        self.canvasImageView.isHidden = true
        self.navigationItem.setRightBarButton(nil, animated: false)

        let redoUndoView = Bundle.main.loadNibNamed("RedoUndoView", owner: nil, options: nil)?[0] as! RedoUndoView
        redoUndoView.undoButton.addTarget(self, action: #selector(geri(_:)), for: .touchUpInside)
        redoUndoView.redoButton.addTarget(self, action: #selector(ileri(_:)), for: .touchUpInside)
        redoUndoView.stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        navigationItem.titleView = redoUndoView
    }
    
    func changeDrawColor(color: UIColor) {
        
    }
    
    public func didSelectSubMenu(activeTextEditIndex:Int, activeEraserEditIndex:Int?) {
        self.activeTextEditIndex = activeTextEditIndex
        if activeEraserEditIndex == 1 {
            self.isEraser = true
            self.doneButton.isHidden = false
            self.activeEraserEditIndex = activeEraserEditIndex
        }
        subMenuCollectionView.reloadData()
    }
    public func changedEraserSize(eraserSize: Float) {
        self.eraserSize = eraserSize
    }

    func getImage() {
        //TODO-This
//        DispatchQueue.main.async {
//            let showGallery = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryController") as! GalleryController
//            showGallery.photoEditorMenuDelegate = self
//            showGallery.modalPresentationCapturesStatusBarAppearance = true
//            self.present(showGallery, animated: true, completion: nil)
//        }
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            DispatchQueue.main.async {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate     = self
                imagePickerController.sourceType   = sourceType
                imagePickerController.cameraDevice = .front
                imagePickerController.modalPresentationStyle = .fullScreen
//                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    func setImageFromGallery(image: UIImage) {
        setImageView(image: image)
    }
    
    func quadraticCrop(image: UIImage) {
        self.presentCropViewController(image: image)
    }
    
    func manualCropImage(ofImageView:UIImageView, withinPoints points:[CGPoint]) -> UIImage? {
        
        //Check if there is start and end points exists
        if points.count >= 2 {
            let path = UIBezierPath()
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2
            var croppedImage:UIImage?
            
            for (index,point) in points.enumerated() {
                
                //Origin
                if index == 0 {
                    path.move(to: point)
                    
                //Endpoint
                } else if index == points.count-1 {
                    path.addLine(to: point)
                    path.close()
                    shapeLayer.path = path.cgPath
                    
                    ofImageView.layer.addSublayer(shapeLayer)
                    shapeLayer.fillColor = UIColor.black.cgColor
                    ofImageView.layer.mask = shapeLayer
                    UIGraphicsBeginImageContextWithOptions(ofImageView.frame.size, false, 1)
                    
                    if let currentContext = UIGraphicsGetCurrentContext() {
                        ofImageView.layer.render(in: currentContext)
                    }

                    let newImage = UIGraphicsGetImageFromCurrentImageContext()

                    UIGraphicsEndImageContext()
                    
                    croppedImage = newImage
                    
                    //Move points
                } else {
                    path.addLine(to: point)
                }
            }
            
            return croppedImage
        } else {
            return nil
        }
    }
    
    func addSticker() {
        addStickersViewController()
    }
    
    func didSelectCartoonEffect(style_id: String) {
        self.style_id = style_id
        self.navigationItem.setRightBarButton(nil, animated: false)
        if self.canvasImageView.subviews[0] is UIImageView {
            let imageView = self.canvasImageView.subviews[0] as! UIImageView
            uploadImageToDeeparteffectsAPI(image: imageView.image!, style_id: style_id) { effectedURL in
                
                if let url = effectedURL {
                    
                    self.showImageView.isHidden = true
                    //TODO-This
//                    self.imageView.sd_setImage(with: URL(string: url)) { (image, error, imageCacheType, url) in
//                        imageView.image = image
//                        self.imageView.image = nil
//                        self.imageView.isHidden = true
//                    }
                    
                    self.cartoonURL = url
                    print("didSelectCartoonEffect:", url)
                    let redoUndoView = Bundle.main.loadNibNamed("RedoUndoView", owner: nil, options: nil)?[0] as! RedoUndoView
                    redoUndoView.undoButton.addTarget(self, action: #selector(self.undoCartoon(_:)), for: .touchUpInside)
                    redoUndoView.redoButton.addTarget(self, action: #selector(self.redoCartoon(_:)), for: .touchUpInside)
                    redoUndoView.stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
                    self.navigationItem.titleView = redoUndoView
                    self.doneButton.isHidden = false
                    
    //                self.imageView.setImage_SD(url!)
                }else {
                    print("didSelectCartoonEffect(): Cartoon url nil")
                }
            }
        }
    }
    
    @objc func undoCartoon(_ sender: UIButton) {
        if self.canvasImageView.subviews[0] is UIImageView {
            let imageView = self.canvasImageView.subviews[0] as! UIImageView
            imageView.image = self.tempImage
        }
    }
    
    @objc func redoCartoon(_ sender: UIButton) {
        if let cartoonUrl = self.cartoonURL {
            if self.canvasImageView.subviews[0] is UIImageView {
                let imageView = self.canvasImageView.subviews[0] as! UIImageView
                //TODO-This
//                imageView.setImage_SD(cartoonUrl)
            }
        }
    }
    
    func startAnimationWithSV() {
        SVProgressHUD.show()
    }
    
    func startAnimation() {
        self.showLoadingView()
    }
    
    func stopAnimation() {
        print("stoppppp::::::::::::.")
        self.dismiss(animated: true)
    }
    
    func showLoadingView(setBlur:Bool = true){
        //TODO-This
//        let controller = LoadingController()
//        controller.setBlur = setBlur
//        controller.modalPresentationStyle = .overFullScreen
//        controller.modalTransitionStyle   = .crossDissolve
//        present(controller, animated: true, completion: nil)
    }

}
//
//
//class LoadingController: UIViewController{
//    
//    var setBlur = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let blurView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
//        BlurHelper.setup(view: blurView)
//        
//        if setBlur {
//            view.addSubview(blurView)
//        }
//
//        let animationView = UIView(frame: CGRect(x: (ScreenSize.SCREEN_WIDTH / 2)  - (100 / 2),
//                                                 y: (ScreenSize.SCREEN_HEIGHT / 2) - (100 / 2),
//                                                 width: 100, height: 100))
//
//        LottieHelper.setAnimation(view: animationView, name: "loader_sticker",loop: true)
//        view.addSubview(animationView)
//    }
//    
//
//}

