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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addContrastLabel(text: "Hello world!", font: UIFont(name: "Courier", size: 15.0)!)
        
/**
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { 
            self.imageView.removeContrastLabel()
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

