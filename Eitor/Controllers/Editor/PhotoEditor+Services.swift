//
//  PhotoEditor+Services.swift
//  Eitor
//
//  Created by Mert Ozkaya on 30.06.2020.
//  Copyright © 2020 app. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension EditorVC {
    func getCartoonEffectList() {
//    //        self.startIndicator()
//        Services.getCartoonEffectList() { (response) in
//            guard let result = response else { return }
//
//            DispatchQueue.main.async {
//                self.cartoonEffects = result.deeparteffects_list
////                self.stopIndicator()
////                print(self.cartoonEffects[0].id)
//                self.mainMenuCollectionview.reloadData()
//                self.subMenuCollectionView.reloadData()
//            }
//        }
    }
    
    func uploadImageToDeeparteffectsAPI(image: UIImage, style_id: String, completion: @escaping(String?) -> Void) {
        self.startAnimation()
//        let dict = ["styleId" : style_id, "imageBase64Encoded" : image.convertImageToBase64()] as [String: Any]
//         if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
//            let url = NSURL(string: "https://api.deeparteffects.com/v1/noauth/upload")!
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue(UserDefaults.standard.string(forKey: "cartoonApiKey") ?? "" , forHTTPHeaderField: "x-api-key")
//            request.httpBody = jsonData
//            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
//                if error != nil{
//                    print(error?.localizedDescription)
//                    completion(nil)
//                }
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                    if let parseJSON = json {
////                        print(parseJSON,parseJSON["submissionId"] ?? "","Burda")
//                        let submissionId = parseJSON["submissionId"] ?? ""
//                       print("uploadImageToDeeparteffectsAPI Submission id:",submissionId)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ){
//                            self.result(submissionId: submissionId as! String ) { response in
//                                completion(response)
//                            }
//                        }
//                    }
//                } catch let error as NSError {
//                    print(error)
//                }
//            }
//            task.resume()
//         }
    }
    
    func result(submissionId:String, handler: @escaping(String?) -> Void){
//        let url = "https://api.deeparteffects.com/v1/noauth/result?submissionId=" + submissionId
//        CartoonResultService.result(url: url) { (completion) in
//            guard let completion = completion else{
//                handler(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                print("completion.url:", completion.url)
//                if completion.status == "finished"{
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
////                        self.imageView.setImage_SD(completion.url)
//                        handler(completion.url)
//                        self.stopAnimation()
//                    }
//                }else if completion.status == "new"{
//                    print("Completion status new")
//                    self.stopAnimation()
//                    handler(nil)
//
//                 }else{
//                   print("Completion status else")
//                    self.stopAnimation()
//                    handler(nil)
//                 }
//            }
//        }
    }
    
    func getTextPatterns() {
//        subMenuCollectionView.alpha = 0
//        Services.getTextPatterns() { response in
//            guard let result = response else { return }
//
//            DispatchQueue.main.async {
//                self.textPatterns = result.text_patterns
//                self.mainMenuCollectionview.reloadData()
//                self.subMenuCollectionView.reloadData()
//                self.subMenuCollectionView.alpha = 1
//            }
//
//        }
        
    }

    
}
