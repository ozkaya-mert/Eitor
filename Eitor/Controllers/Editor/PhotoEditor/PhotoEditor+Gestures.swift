//
//  PhotoEditor+Gestures.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation


import UIKit

extension EditorVC : UIGestureRecognizerDelegate  {
    
    /**
     UIPanGestureRecognizer - Moving Objects
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
//        print("panGesture")

        if let view = recognizer.view {
            if !isEraser {
                moveView(view: view, recognizer: recognizer)
            }
//            if view is UIImageView {
//                    //Tap only on visible parts on the image
//                    if recognizer.state == .began {
//
//                        moveView(view: touchedView, recognizer: recognizer)
//                        print("panGesture çalıştı")
//
//
////                        for imageView in subImageViews(view: canvasImageView) {
////                            if imageView.tag == 0 {
////                                print("imajj2")
////                            }else {
////                                print("diğer2")
////                            }
////                            let location = recognizer.location(in: imageView)
////                            let alpha = imageView.alphaAtPoint(location)
////                            if alpha > 0 {
////                                imageViewToPan = imageView
////                                break
////                            }
////                        }
//                    }
////                    if imageViewToPan != nil {
////                        moveView(view: imageViewToPan!, recognizer: recognizer)
////                    }
//            } else {
//                moveView(view: view, recognizer: recognizer)
//            }
        }

    }
    
    /**
     UIPinchGestureRecognizer - Pinching Objects
     If it's a UITextView will make the font bigger so it doen't look pixlated
     */
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if !isEraser {
            if let view = recognizer.view {
                if view is UITextView {
                    let textView = view as! UITextView
                    
                    if textView.font!.pointSize * recognizer.scale < 90 {
                        let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                        textView.font = font
                        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                     height:CGFloat.greatestFiniteMagnitude))
                        textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                      height: sizeToFit.height)
                    } else {
                        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                     height:CGFloat.greatestFiniteMagnitude))
                        textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                      height: sizeToFit.height)
                    }
                    
                    
                    textView.setNeedsDisplay()
                } else if view is UIImageView {
                    view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                }else {
                    view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                }
                recognizer.scale = 1
            }
        }
        
        
//        if recognizer.state == .ended {
//            if let view = recognizer.view {
//                if view is UIImageView {
//                    self.canvasImageView.isHidden = false
//                    print("pincGesture imageView")
//                }
//            }
//        }
    }
    
    /**
     UIRotationGestureRecognizer - Rotating Objects
     */
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        
        if !isEraser {
            if let view = recognizer.view {
                view.transform = view.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0
            }
        }
        
        
//        if recognizer.state == .ended {
//            if let view = recognizer.view {
//                if view is UIImageView {
//                    self.canvasImageView.isHidden = false
//                    print("rotationGesture imageView")
//                }
//            }
//            print("rotationGesture Bitti")
//        }
    }
    
    /**
     UITapGestureRecognizer - Taping on Objects
     Will make scale scale Effect
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if !isEraser {
            if let view = recognizer.view {
                if view is UIImageView {
                    for imageView in subImageViews(view: canvasImageView) {
                        let location = recognizer.location(in: imageView)
                        let alpha = imageView.alphaAtPoint(location)
                        if alpha > 0 {
                            scaleEffect(view: imageView)
                            break
                        }
                    }
                    print("TapGesture for imageview")
                } else {
                    scaleEffect(view: view)
                }
            }
        }
        
    }
    
    /*
     Support Multiple Gesture at the same time
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !stickersVCIsVisible {
                addStickersViewController()
            }
        }
    }
//    
//    // to Override Control Center screen edge pan from bottom
//    override public var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    /**
     Scale Effect
     */
    func scaleEffect(view: UIView) {
//        view.superview?.bringSubviewToFront(view)
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
//                            self.canvasImageView.isHidden = false
                            print("scale bitti")

                        }
        })

        
    }
    
    /**
     Moving Objects 
     delete the view if it's inside the delete view
     Snap the view back if it's out of the canvas
     */

    func moveView(view: UIView, recognizer: UIPanGestureRecognizer)  {
        
//        hideToolbar(hide: true)
        deleteView.isHidden = false
        
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)

        view.center = CGPoint(x: view.center.x + recognizer.translation(in: showImageView).x,
                              y: view.center.y + recognizer.translation(in: showImageView).y)
        
        recognizer.setTranslation(CGPoint.zero, in: canvasImageView)
        
        if let previousPoint = lastPanPoint {
            //View is going into deleteView
            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                    view.center = recognizer.location(in: self.canvasImageView)
                })
            }
                //View is going out of deleteView
            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
                //Scale to original Size
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 4, y: 4)
                    view.center = recognizer.location(in: self.canvasImageView)
                })
            }
        }
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            imageViewToPan = nil
            lastPanPoint = nil
//            hideToolbar(hide: false)
            deleteView.isHidden = true
            let point = recognizer.location(in: self.view)
            
            if deleteView.frame.contains(point) { // Delete the view
                //Sürüklenerek silinmek istenen view textview ise
                if view is UITextView {
                    print("TEXTVİEW DOĞRU")
                    let textView = view as! UITextView

                    /** textModels içinde sürüklenrek silinmek istenen textView varsa bul ve kaldır */
                    var i = 0
                    for item in textModels {
                        if textView == item.textView {
                            print("Buldumm")
                            break
                        }
                        i += 1
                    }
                    textModels.remove(at: i)
                }
                view.removeFromSuperview()
                
                if #available(iOS 10.0, *) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            } else if !canvasImageView.bounds.contains(view.center) { //Snap the view back to canvasImageView
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.canvasImageView.center
                })
                
            }
        }
    }
    
    func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        for imageView in view.subviews {
            if imageView is UIImageView {
                imageviews.append(imageView as! UIImageView)
            }
        }
        return imageviews
    }
}


