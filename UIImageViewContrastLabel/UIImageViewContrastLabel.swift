//
//  UIImageViewContrastLabel.swift
//  UIImageViewContrastLabel
//
//  Created by Bohdan Ivanov on 19.08.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public var contrastLabelLayerName: String {
        get {
            return "bivanov.UIImageViewContrastLabel.layer"
        }
    }
    
    /// Create image from another image; resulted image is in black and white
    /// colors only. Black pixels correspond to bright pixels of original image, white to darker ones.
    /// - Parameter image: to be processed
    /// - Returns: black and white image or nil in case of error
    public func createThresholdedImage(from image: UIImage) -> UIImage? {
        
        let bundle = Bundle(identifier: "bivanov.UIImageViewContrastLabel")!
        
        let kernelString = try! String(contentsOfFile: bundle.path(forResource: "threshold",
                                                                   ofType: "cikernel")!)
        
        let kernel = CIColorKernel(string: kernelString)
        
        if let cgImage = image.cgImage {
            let ciImage = CIImage(cgImage: cgImage)
            
            if #available(iOS 9.0, *) {
                if let output = kernel?.apply(withExtent: ciImage.extent,
                                              arguments: [CISampler(image: ciImage)]) {
                    
                    return UIImage(ciImage: output)
                }
            } else {
                if let output = kernel?.apply(withExtent: ciImage.extent,
                                              arguments: [ciImage]) {
                    
                    return UIImage(ciImage: output)
                }
            }
            
        }
        
        return nil
    }
    
    /// Adds contrast label to UIImageView; label's colors are contrast to image itself, e.g. it will have white
    /// regions on dark image region and vice versa.
    /// - Parameter text: text to be displayed
    /// - Parameter font: font to be used
    /// - Parameter position: relative position (from 0 to 1 for both dimensions) for label to be drawn in parent frame
    public func addContrastLabel(text: String,
                          font: UIFont,
                          position: CGPoint = CGPoint.zero) {
        guard self.image != nil else {
            return
        }
        
        guard position.x >= 0.0 && position.x <= 1.0 &&
            position.y >= 0.0 && position.y <= 1.0 else {
                return
        }
        
        let backgroundImage = self.image!
        
        let thresholdLayer = CALayer()
        thresholdLayer.frame = self.bounds
        
        let context = CIContext(options: nil)
        if let ciImage = self.createThresholdedImage(from: backgroundImage)?.ciImage {
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                
                thresholdLayer.contents = cgImage
            }
        }
        
        let textLayer = CATextLayer()
        textLayer.frame =  CGRect(x: self.bounds.size.width * position.x,
                                  y:  self.bounds.size.height * position.y,
                                  width: self.bounds.size.width,
                                  height: self.bounds.size.height)
        textLayer.font = font
        textLayer.foregroundColor = UIColor.black.cgColor
        
        textLayer.string = text
        
        thresholdLayer.mask = textLayer
        thresholdLayer.name = self.contrastLabelLayerName
        
        self.layer.addSublayer(thresholdLayer)
    }
    
    /// Removes contrast label from UIImageView if any is present
    public func removeContrastLabel() {
        if let layer = self.layer.sublayers?.filter({ (layer) -> Bool in
            layer.name == self.contrastLabelLayerName
        }).first {
            layer.removeFromSuperlayer()
        }
    }
    
}
