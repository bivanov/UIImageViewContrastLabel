//
//  ThresholdFilter.swift
//  UIImageViewContrastLabel
//
//  Created by Bohdan Ivanov on 01.09.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import UIKit

class ThresholdFilter: CIFilter {
    
    var inputImage: CIImage?
    
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
        
        let kernel = CIColorKernel(string: kernelString)
        
        if let inputImage = self.inputImage {
            
            if #available(iOS 9.0, *) {
                if let output = kernel?.apply(withExtent: inputImage.extent,
                                              arguments: [CISampler(image: inputImage)]) {
                    
                    return output.applyingFilter("CIBoxBlur",
                                                 withInputParameters: blurParameters)
                }
            } else {
                if let output = kernel?.apply(withExtent: inputImage.extent,
                                              arguments: [inputImage]) {
                    
                    return output.applyingFilter("CIBoxBlur",
                                                 withInputParameters: blurParameters)
                }
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
