//
//  UIImageViewContrastLabel.swift
//  UIImageViewContrastLabel
//
//  Created by Bohdan Ivanov on 19.08.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import UIKit

/// Layer that can display constrast label based on provided CGImage.
/// Basic usage of CAContrastLabelLayer is with UIImageView.
/// - Note: CAContrastLabelLayer properties are not animatable and it is not designed
/// to be animated directly. If you want to animate underlying text layer, access corresponding property.
/// - Note: You should not want to change CAContrastLabelLayer position or frame manually, as it will not
/// provide desired effect. If you want to relocate text, use `textPosition` property.
public class CAContrastLabelLayer: CALayer {
    
    /// Text layer that is used as mask for CAContrastLabelLayer. 
    /// If you want to provide some animations to text, use this property.
    public private(set) var textLayer: CATextLayer
    
    /// Text to be displayed.
    public var text: String? {
        didSet {
            self.textLayer.string = text
            self.recalculateTextLayerFrame()
        }
    }
    
    /// Font to be used to draw text.
    public var font: UIFont? {
        didSet {
            if let font = font {
                self.textLayer.font =
                    CTFontCreateWithName(font.fontName as NSString, 12.0, nil)
                self.textLayer.fontSize = font.pointSize
                self.recalculateTextLayerFrame()
            }
            
        }
    }
    
    /// Relative position of text inside of layer frame.
    /// You may use values from 0 to 1 to determine x and y position. If x or y value is
    /// out of this range, new value will be ignored.
    public var textPosition: CGPoint {
        get {
            return CGPoint(x: self.textLayer.position.x / self.bounds.size.width,
                           y: self.textLayer.position.y / self.bounds.size.height)
        }
        set {
            if newValue.x >= 0.0 && newValue.x <= 1.0 &&
                newValue.y >= 0.0 && newValue.y <= 1.0 {
                self.textLayer.position = CGPoint(x: self.bounds.size.width * newValue.x,
                                                  y: self.bounds.size.height * newValue.y)
            }
        }
    }
    
    /// Image that will be used background. 
    /// - Note: Should be provided by `UIImageView.createThresholdedImage` extension method.
    var image: CGImage? {
        didSet {
            self.contents = image
        }
    }
    
    public override init() {
        self.textLayer = CATextLayer()
        
        super.init()
        
        self.textPosition = CGPoint.zero
        self.textLayer.foregroundColor = UIColor.black.cgColor
        self.mask = self.textLayer
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.textLayer = CATextLayer()
        
        super.init(coder: aDecoder)
        
        self.textPosition = CGPoint.zero
    }
    
    private func recalculateTextLayerFrame() {
        if let text = self.text as NSString?,
            let font = self.font {
            
            let attributes: [String: Any] =
                [NSFontAttributeName: font,
                 NSForegroundColorAttributeName: UIColor.black.cgColor]
            
            let bounds = text.boundingRect(with: self.frame.size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
            
            self.textLayer.frame = CGRect(x: self.textLayer.frame.origin.x,
                                          y: self.textLayer.frame.origin.y,
                                          width: bounds.width,
                                          height: bounds.height)
        }
    }
}

extension UIImageView {
    
    public var contrastLabelLayerName: String {
        get {
            return "bivanov.UIImageViewContrastLabel.layer"
        }
    }
    
    /// Create image from another image; resulted image is in black and white
    /// colors only. Black pixels correspond to bright pixels of original image, white to darker ones.
    /// - Parameter image: Image to be processed.
    /// - Returns: Black and white image or nil in case of error.
    private func createThresholdedImage(from image: UIImage) -> UIImage? {
        
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
        
        guard position.x >= 0.0 && position.x <= 1.0 &&
            position.y >= 0.0 && position.y <= 1.0 else {
                return nil
        }
        
        let backgroundImage = self.image!
        
        let thresholdLayer = CAContrastLabelLayer()
        thresholdLayer.frame = self.bounds
        thresholdLayer.font = font
        thresholdLayer.textPosition = position
        thresholdLayer.text = text
        
        let context = CIContext(options: nil)
        if let ciImage = self.createThresholdedImage(from: backgroundImage)?.ciImage {
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                
                thresholdLayer.image = cgImage
            }
        }

        thresholdLayer.name = self.contrastLabelLayerName
        
        self.layer.addSublayer(thresholdLayer)
        
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
