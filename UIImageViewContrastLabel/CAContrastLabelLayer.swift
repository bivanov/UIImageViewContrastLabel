//
//  CAContrastLabeLayer.swift
//  UIImageViewContrastLabel
//
//  Created by Bohdan Ivanov on 01.09.17.
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
        self.textLayer.alignmentMode = CATextLayerAlignmentMode.center
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
            
            let attributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: font,
                 NSAttributedString.Key.foregroundColor: UIColor.black.cgColor]
            
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
