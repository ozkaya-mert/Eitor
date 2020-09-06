//
//  PhotoEditor+Drawing.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/16/17.
//
//
import UIKit

class DrawingModel {
    var isSwipe: Bool
    var currentPoint: CGPoint?
    var lastPoint: CGPoint
    var drawIndex: Int
    var eraserSize: Float
    var drawColor: UIColor?
    
    init(isSwipe: Bool, current: CGPoint?, last: CGPoint, index: Int, eraserSize: Float, color: UIColor?) {
        self.isSwipe = isSwipe
        self.currentPoint = current
        self.lastPoint = last
        self.drawIndex = index
        self.eraserSize = eraserSize
        self.drawColor = color
    }
}


extension EditorVC {
    
    @objc func geri(_ sender: UIButton) {
        
        if control == .draw {
            
            if drawLines.count > 0 {
                var i = drawLines.count - 1
                let lastIndex = drawLines[i].drawIndex
                while i >= 0 {
                    if drawLines[i].drawIndex == lastIndex {
                        removedDrawLines.append(drawLines[i])
                        _ = drawLines.remove(at: i)
                    }else {
                        break
                    }
                    
                    i -= 1
                }
                
                restartDraw()
            }else {
                // butonu pasit hale getir
            }
        }else {
            if clearLines.count > 0 {
                var i = clearLines.count - 1
                let lastIndex = clearLines[i].drawIndex
                while i >= 0 {
                    if clearLines[i].drawIndex == lastIndex {
                        removedClearLines.append(clearLines[i])
                        _ = clearLines.remove(at: i)
                    }else {
                        break
                    }
                    
                    i -= 1
                }
                
                restartDraw()
            }else {
                // butonu pasit hale getir
            }
        }
    }
    
    @objc func ileri(_ sender: UIButton) {
        if control == .draw {
            if removedDrawLines.count > 0 {
                var i = removedDrawLines.count - 1
                let lastIndex = removedDrawLines[i].drawIndex
                while i >= 0 {
                    if removedDrawLines[i].drawIndex == lastIndex {
                        drawLines.append(removedDrawLines[i])
                        _ = removedDrawLines.remove(at: i)
                    }else {
                        break
                    }
                    
                    i -= 1
                }
                
                restartDraw()
            }else {
                // butonu pasit hale getir
            }
        }else {
            if removedClearLines.count > 0 {
                var i = removedClearLines.count - 1
                let lastIndex = removedClearLines[i].drawIndex
                while i >= 0 {
                    if removedClearLines[i].drawIndex == lastIndex {
                        clearLines.append(removedClearLines[i])
                        _ = removedClearLines.remove(at: i)
                    }else {
                        break
                    }
                    
                    i -= 1
                }
                
                restartDraw()
            }else {
                // butonu pasit hale getir
            }
        }
    }
    
//    func restartDraw() {
//        if let tempImage = tempImage {
//
//            self.imageView.contentMode = .scaleAspectFit
//            self.imageView.image = tempImage
////            if canvasImageView.subviews[0] is UIImageView {
////                let imageView = canvasImageView.subviews[0] as! UIImageView
////                imageView.contentMode = .scaleAspectFit
////                imageView.image = tempImage
////            }
//
//            for item in lines {
//                if item.isSwipe {
//                    drawLineFrom(item.lastPoint, toPoint: item.currentPoint!, eraserSize: item.eraserSize)
//                }else {
//                    drawLineFrom(item.lastPoint, toPoint: item.lastPoint, eraserSize: item.eraserSize)
//                }
//
//            }
//        }
//    }
//
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        if isEraser == true {
//            guard let gestureRecognizers = self.imageView.gestureRecognizers else{
//                return
//            }
//
//            gestureRecognizers[0].isEnabled = false
//
//            isSwiped = false
//            if let touch = touches.first {
//                lastPoint = touch.location(in: self.imageView)
//                indexDraw += 1
//                removedLines.removeAll()
//            }
//        }
//    }
    
    func restartDraw() {

        
        if let tempImage = tempImage {
            showImageView.image = tempImage
            self.showImageView.contentMode = .scaleAspectFit
            for item in clearLines {
                if item.isSwipe {
                    drawLineFrom(item.lastPoint, toPoint: item.currentPoint!, eraserSize: item.eraserSize, blendMode: .clear, drawColor: nil)
                }else {
                    drawLineFrom(item.lastPoint, toPoint: item.lastPoint, eraserSize: item.eraserSize, blendMode: .clear, drawColor: nil)
                }
            }
            
            for item in drawLines {
                if item.isSwipe {
                    drawLineFrom(item.lastPoint, toPoint: item.currentPoint!, eraserSize: item.eraserSize, blendMode: .normal, drawColor: item.drawColor)
                }else {
                    drawLineFrom(item.lastPoint, toPoint: item.lastPoint, eraserSize: item.eraserSize, blendMode: .normal, drawColor: item.drawColor)
                }
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if control == .draw {
            isSwiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.showImageView)
                indexDraw += 1
                removedDrawLines.removeAll()
            }
        }else if control == .manualCrop {
            if let touch = touches.first as UITouch?{
                let touchPoint = touch.location(in: self.showImageView)
                if isLogEnabled {
                    debugPrint("touch begin to : \(touchPoint)")
                }
                cropPath = UIBezierPath()
                cropPoints.removeAll()
                cropPoints.append(touchPoint)
                cropPath.move(to: touchPoint)
            }
        } else{
            if isEraser == true {
                isSwiped = false

                if let touch = touches.first {
                    lastPoint = touch.location(in: self.showImageView)
                    indexClearDraw += 1
                    removedClearLines.removeAll()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if control == .draw {
            isSwiped = true
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.showImageView)
                drawLineFrom(lastPoint, toPoint: currentPoint, eraserSize: drawSize, blendMode: .normal,  drawColor: drawColor)
                
                let a = DrawingModel(isSwipe: self.isSwiped, current: currentPoint, last: lastPoint, index: indexDraw, eraserSize: drawSize, color: self.drawColor)
                self.drawLines.append(a)

                lastPoint = currentPoint
            }
        } else if control == .manualCrop {
            if let touch = touches.first as UITouch?{
                let touchPoint = touch.location(in: self.showImageView)
                if isLogEnabled {
                    print("touch moved to : \(touchPoint)")
                }
                cropPoints.append(touchPoint)
                cropPath.addLine(to: touchPoint)
                addNewPathToImage()
            }
        } else {
            if isEraser {
                isSwiped = true
                if let touch = touches.first {
                    let currentPoint = touch.location(in: self.showImageView)
                    drawLineFrom(lastPoint, toPoint: currentPoint, eraserSize: eraserSize, blendMode: .clear,  drawColor: nil)
                    
                    let a = DrawingModel(isSwipe: self.isSwiped, current: currentPoint, last: lastPoint, index: indexClearDraw, eraserSize: eraserSize, color: nil)
                    self.clearLines.append(a)
                    lastPoint = currentPoint
                }
            }
        }

    }
    
    override public func touchesEnded(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        
        if control == .draw {
            if !isSwiped {
                drawLineFrom(lastPoint, toPoint: lastPoint, eraserSize: drawSize, blendMode: .normal, drawColor: drawColor)
                let a = DrawingModel(isSwipe: self.isSwiped, current: lastPoint, last: lastPoint, index: indexDraw, eraserSize: drawSize, color: self.drawColor)
                self.drawLines.append(a)
            }
        }else if control == .manualCrop {
            if let touch = touches.first as UITouch?{
                let touchPoint = touch.location(in: self.showImageView)
                if isLogEnabled {
                    print("touch ended at : \(touchPoint)")
                }
                cropPoints.append(touchPoint)

                cropPath.addLine(to: touchPoint)
                addNewPathToImage()
                cropPath.close()
            }
        } else {
            if isEraser {
                if !isSwiped {
                    drawLineFrom(lastPoint, toPoint: lastPoint, eraserSize: eraserSize, blendMode: .clear, drawColor: nil)
                    let a = DrawingModel(isSwipe: self.isSwiped, current: lastPoint, last: lastPoint, index: indexClearDraw, eraserSize: eraserSize, color: nil)
                    self.clearLines.append(a)
                }
            }
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if control == .manualCrop {
            if let touch = touches.first as UITouch?{
                let touchPoint = touch.location(in: self.showImageView)
                if isLogEnabled {
                    print("touch canceled at : \(touchPoint)")
                }
                
                cropPath.close()
            }
        }
        
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint, eraserSize: Float, blendMode: CGBlendMode, drawColor: UIColor?) {
        
        
            let rect = self.showImageView.bounds
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            
            self.showImageView.image?.draw(in: CGRect(x: self.showImageView.bounds.origin.x, y: self.showImageView.bounds.origin.y, width: self.showImageView.bounds.size.width, height: self.showImageView.bounds.size.height))
            self.showImageView.contentMode = .scaleAspectFit
                
            context!.move(to: fromPoint)
            context!.addLine(to: toPoint)
            context!.setLineCap(.round)
            context!.setLineWidth(CGFloat(5 * eraserSize))
        
            if control == .draw {
                if let color = drawColor {
                    context?.setAlpha(1.0)
                    context?.setFillColor(color.cgColor)
                    context?.setStrokeColor(color.cgColor)
                }
            }else {
                context!.setBlendMode(blendMode)
            }
            context!.strokePath()
            
            self.showImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

    }
    
//    func drawRect(rect: CGRect) {
//        let aPath = UIBezierPath()
//
//        aPath.move(to: CGPoint(x:<#start x#>, y:<#start y#>))
//        aPath.addLine(to: CGPoint(x: <#end x#>, y: <#end y#>))
//
//        // Keep using the method addLine until you get to the one where about to close the path
//        aPath.close()
//
//        // If you want to stroke it with a red color
//        UIColor.red.set()
//        aPath.lineWidth = <#line width#>
//        aPath.stroke()
//    }
//    

    
}
