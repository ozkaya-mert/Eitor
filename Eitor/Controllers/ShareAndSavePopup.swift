//
//  ShareAndSavePopup.swift
//  Eitor
//
//  Created by Mert Ozkaya on 29.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import Spring
import VisualEffectView
    
class ShareAndSavePopup: BaseViewController {

    @IBOutlet weak var visualEffectView: VisualEffectView!
    @IBOutlet weak var springView: SpringView!
    var image: UIImage?
    var editorDelegate: EditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        BlurHelper.setup(view: visualEffectView,blurColor: UIColor.gray.withAlphaComponent(0.5))
        view.backgroundColor = .clear
    }
    
    @IBAction func saveToLibrary(_ sender: UIButton) {
        let saver = Saver(albumName: "Eitor")
        if let image = self.image {
            saver.saveImage(image) { (result, error) in
                if let error = error {
                    print("Kaydederken hata:", error.localizedDescription)
                }else {
                    if result {
                        if let delegate = self.editorDelegate {
                            DispatchQueue.main.async {
                                self.closeView { (_) in
                                    self.dismiss(animated: true)
                                    delegate.savedToLibrary(message: "Fotoğraf başarıyla kaydedildi")
                                }
                            }
                            
                        }
                    }else {
                        print("")
                        if let delegate = self.editorDelegate {
                            DispatchQueue.main.async {
                                self.closeView { (_) in
                                    self.dismiss(animated: true)
                                    
                                    delegate.savedToLibrary(message: "Fotoğraf kaydedilirken bir hata oluştu")
                                }
                            }
                        }
                    }
                }

            }

        }
        
    }
    
    @IBAction func share(_ sender: UIButton) {
        if let image = self.image {
            share(image: image)
        }
    }
    
    fileprivate func share(image: UIImage) {
        
//        let text: String = "--"
//        let webSiteUrl = NSURL(string:"https://www.test.net")
        let shareAll: Any = [image]
        let activityViewController = UIActivityViewController(activityItems: shareAll as! [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func showView(){
        springView.isHidden = true
        Helpers.delay(0.3) {
            self.springView.isHidden = false
            self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.5)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        closeView { (_) in
            self.dismiss(animated: true)
        }
    }
    
    func closeView(completion:@escaping(Bool) -> Void) {
        self.showSpringAnimation(view: self.springView, type: .fadeInUp, duration: 0.3 ,out: true)
        Helpers.delay(0.5) {
            self.springView.isHidden = true
            completion(true)
        }
    }

}
