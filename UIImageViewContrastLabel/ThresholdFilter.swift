//
//  ThresholdFilter.swift
//  UIImageViewContrastLabel
//
//  Created by Bohdan Ivanov on 01.09.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import UIKit

class ThresholdFilter: CIFilter {
    
    @objc var inputImage: CIImage?
    var darkPartsColor: CIColor = CIColor(cgColor: UIColor.black.cgColor)
    var lightPartsColor: CIColor = CIColor(cgColor: UIColor.white.cgColor)
    
    override var name: String {
        get {
            return "ThresholdFilter"
        }
        set { }
    }
    
    override var outputImage: CIImage? {
        let bundle = Bundle(identifier: "bivanov.UIImageViewContrastLabel")!
        
        var kernelString: String
        
        do {
            kernelString = try String(contentsOfFile: bundle.path(forResource: "threshold",
                                                                       ofType: "cikernel")!)
        } catch {
            return nil
        }
        
        let blurParameters = [
            kCIInputRadiusKey: 3.0
        ]
        
        let kernel = CIColorKernel(source: kernelString)
        
        if let inputImage = self.inputImage {
            let arguments: [Any]
             
            if #available(iOS 9.0, *) {
                arguments = [CISampler(image: inputImage),
                             self.darkPartsColor,
                             self.lightPartsColor]
            } else {
                arguments = [inputImage,
                             self.darkPartsColor,
                             self.lightPartsColor]
            }
            
            if let output = kernel?.apply(extent: inputImage.extent,
                                          arguments: arguments) {
                
                return output.applyingFilter("CIBoxBlur",
                                             parameters: blurParameters)
            }
            
        }
        
        return nil
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
