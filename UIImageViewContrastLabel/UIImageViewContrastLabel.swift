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
        return "bivanov.UIImageViewContrastLabel.layer"
    }
    
    /// Adds contrast label to UIImageView; label's colors are contrast to image itself, e.g. it will have white
    /// regions on dark image region and vice versa.
    /// - Parameter text: text to be displayed.
    /// - Parameter font: font to be used.
    /// - Parameter position: relative position (from 0 to 1 for both dimensions) for label to be drawn in parent frame.
    /// - Returns: In case of success created layer; nil otherwise.
    @discardableResult
    public func addContrastLabel(text: String,
                                 font: UIFont,
                                 position: CGPoint = CGPoint.zero) -> CAContrastLabelLayer? {
        guard self.image != nil else {
            return nil
        }
        
        let backgroundImage = self.image!
        
        let thresholdLayer = CAContrastLabelLayer()
        thresholdLayer.frame = self.bounds
        thresholdLayer.font = font
        thresholdLayer.text = text
        
        let context = CIContext(options: nil)

        if let cgImage = backgroundImage.cgImage {
            
            let ciImage = CIImage(cgImage: cgImage)
            
            let thresholdFilter = ThresholdFilter()
            thresholdFilter.setValue(ciImage, forKey: kCIInputImageKey)
            
            if let thresholdedImage = thresholdFilter.outputImage,
                let finalImage = context.createCGImage(thresholdedImage, from: thresholdedImage.extent) {
                thresholdLayer.image = finalImage
            }
        }

        thresholdLayer.name = self.contrastLabelLayerName
        
        self.layer.addSublayer(thresholdLayer)
        
        thresholdLayer.textPosition = position
        
        return thresholdLayer
    }
    
    /// Removes contrast label from UIImageView if any is present.
    public func removeContrastLabel() {
        if let layer = self.layer.sublayers?.filter({ (layer) -> Bool in
            layer.name == self.contrastLabelLayerName
        }).first {
            layer.removeFromSuperlayer()
        }
    }
    
}
