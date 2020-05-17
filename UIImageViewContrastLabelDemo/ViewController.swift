//
//  ViewController.swift
//  UIImageViewContrastLabelDemo
//
//  Created by Bohdan Ivanov on 19.08.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import UIKit
import UIImageViewContrastLabel

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var constrastLayer: CAContrastLabelLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constrastLayer = imageView.addContrastLabel(text: "Hello world!",
                                                         font: UIFont(name: "Courier", size: 30.0)!,
                                                         position: CGPoint(x: 0.5, y: 0.5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
//            self.animateContrastLabel()
            self.constrastLayer.textPosition = CGPoint(x: 0.5, y: 0.7)
        }

    }
    
    func animateContrastLabel() {
        let animation = CABasicAnimation(keyPath: #keyPath(CATextLayer.position))
        animation.duration = 4.0
        animation.repeatCount = 1.0
        animation.fromValue = self.constrastLayer.textLayer.position
        animation.toValue = CGPoint(x: self.constrastLayer.textLayer.position.x,
                                    y: 300)
        
        self.constrastLayer.textLayer.add(animation, forKey: "position")
    }

}
