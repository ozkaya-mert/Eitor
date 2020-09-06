//
//  PhotoEditor+RemoveBackground.swift
//  Eitor
//
//  Created by Mert Ozkaya on 4.07.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit
import CoreML

@available(iOS 12.0, *)
class BackgroundRemoval {
    let model = DeepLabV3()

    init() {
    }
    
    public func getProcessTime(_ start: DispatchTime,_ end: DispatchTime) -> Double {
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime)
        
        return timeInterval/1000000000
    }
    
    public func removeBackground(image:UIImage) -> UIImage? {

            var resized_Image = image.resized(to: CGSize(width: 513, height: 513))
            print("ResizedImage", resized_Image)
            let start = DispatchTime.now()
            guard let resizedImage = resized_Image.jpegData(compressionQuality: 1.0)?.uiImage else {
                return nil
            }
            
            if let pixelBuffer = resizedImage.pixelBuffer(width: Int(resizedImage.size.width), height: Int(resizedImage.size.height)){
                let end = DispatchTime.now()

                print("Time1 to evaluate problem: \(self.getProcessTime(start, end)) seconds")
                Thread.sleep(forTimeInterval: 0.025)
                if let outputImage = (try? self.model.prediction(image: pixelBuffer))?.semanticPredictions.image(min: 0, max: 1, axes: (0,0,1)), let outputCIImage = CIImage(image:outputImage){
                    let end = DispatchTime.now()

                    print("Time2 to evaluate problem: \(self.getProcessTime(start, end)) seconds")
                    Thread.sleep(forTimeInterval: 0.025)
                    if let maskImage = self.removeWhitePixels(image:outputCIImage), let resizedCIImage = CIImage(image: resizedImage), let compositedImage = self.composite(image: resizedCIImage, mask: maskImage){
                        let end = DispatchTime.now()

                        print("Time3 to evaluate problem: \(self.getProcessTime(start, end)) seconds")
                        Thread.sleep(forTimeInterval: 0.025)
                         return UIImage(ciImage: compositedImage).resized(to: CGSize(width: image.size.width, height: image.size.height))
                    }
                }
            }
        
        
        
        return nil
    }
    
    private func removeWhitePixels(image:CIImage) -> CIImage?{
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(image, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }
    
    private func composite(image:CIImage,mask:CIImage) -> CIImage?{
        Thread.sleep(forTimeInterval: 0.025)
        return CIFilter(name:"CISourceOutCompositing",parameters:
            [kCIInputImageKey: image,kCIInputBackgroundImageKey: mask])?.outputImage
    }
    
    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func chromaKeyFilter() -> CIFilter? {
        let start = DispatchTime.now()

        let size = 64
        var cubeRGB = [Float]()
        
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            Thread.sleep(forTimeInterval: 0.025)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        var data = Data()
        var i = 0
        while i < cubeRGB.count {
            withUnsafePointer(to: &cubeRGB[i]) { data.append(UnsafeBufferPointer(start: $0, count: 1)) } // ok
            i += 1
        }

        print(data.count)
//        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))
        
        let colorCubeFilter = CIFilter(name: "CIColorCube", parameters: ["inputCubeDimension": size, "inputCubeData": data])
        let end = DispatchTime.now()
        print("chromaKeyFilter Time to evaluate problem: \(getProcessTime(start, end)) seconds")
        
        return colorCubeFilter
    }
    
    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}

extension Data {
    init<T>(value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    mutating func append<T>(value: T) {
        withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) in
            append(UnsafeBufferPointer(start: ptr, count: 1))
        }
    }
}
