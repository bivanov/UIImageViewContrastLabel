# UIImageViewContrastLabel

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Swift extension for UIImageView that allows to draw contrast label upon image content 

## Manual installation

Download UIImageViewContrastLabel.swift and threshold.cikernel from UIImageViewContrastLabel folder, add them to your project.

Change `let bundle = Bundle(identifier: "bivanov.UIImageViewContrastLabel")!` to whatever bundle you're using in UIImageViewContrastLabel.swift

## Carthage installation

Add `github "bivanov/UIImageViewContrastLabel"` to your Cartfile

## Usage 

### Basic usage

```
class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
		imageView.addContrastLabel(text: "Hello world!", font: UIFont(name: "Courier", size: 15.0)!)
	}

	// ...
}
```

If you want to place label not in left upper corner of image view, you may specify relative position with coordinates in range from 0 to 1:

```
let text = "Hello world!"
let font = UIFont(name: "Courier", size: 15.0)!
let position = CGPoint(x: 0.2, y: 0.5)
        
imageView.addContrastLabel(text: text, font: font, position: position)
```

You can specify colors that will be used for "light" and "dark" parts of contrast label:

```
let darkPartsColor =
	CIColor(red: 137.0 / 255.0, green: 32.0 / 255.0, blue: 29.0 / 255.0)
let lightPartsColor =
	CIColor(red: 19.0 / 255.0, green: 44.0 / 255.0, blue: 85.0 / 255.0)
let position = CGPoint(x: 0.5, y: 0.5)
        
self.constrastLayer = imageView.addContrastLabel(text: "Hello world!",
                                                 font: UIFont(name: "Helvetica", size: 45.0)!,
                                                 position: position,
                                                 darkPartsColor: darkPartsColor,
                                                 lightPartsColor: lightPartsColor)
```

By default, these colors are white and black correspondingly.

To remove contrast label from UIImageView, just call

```
imageView.removeContrastLabel()
```

### Animations

CAContrastLabelLayer that is being used under the hood is not directly animatable, but you can animate underlying text layer: 

```
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var constrastLayer: CAContrastLabelLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constrastLayer = imageView.addContrastLabel(text: "Hello world!",
                                               font: UIFont(name: "Courier", size: 15.0)!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.animateContrastLabel()
        }

    }

    // ... 
    
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
```

CAContrastLabelLayer has `textPosition` property to control relative position of text, but this property is not animatable as well.

## Demo screenshots

<img src="https://github.com/bivanov/UIImageViewContrastLabel/blob/master/Screenshots/Scrn1.png" alt="Demo screenshot 1" width="40%" height="40%"> <img src="https://github.com/bivanov/UIImageViewContrastLabel/blob/master/Screenshots/Scrn3.png" alt="Demo screenshot 2" width="40%" height="40%">

Demo image by [Katie Walker](https://www.flickr.com/photos/eilonwy77/9156784796/in/photolist-eX9V6W-4CugZT-6SaDQd-6JVfBq-o4HmKv-csUF5y-6ch3Yr-8gqyVs-8xY799-8gnqwK-89JCVc-89MUh1-nC5dLZ-3jHvV2-qseZKc-8xXWnu-6UNCRr-bTvNxK-8gnhwv-4nzMev-nFcAP-6PFSvP-aa2ypi-6hH4cT-e5zsAu-8vpBDL-g5BND-cA2i8m-Jh6Vr-aswLN5-6AE2po-8RuEMv-847bCY-7nKn9m-98Va1C-haGvas-amzQHW-9guVqe-dgUSwH-bX92t5-5d8zh4-9gouWH-5px1t-RvJ15n-6LUTvB-847bNU-qVd4i1-6ZqjKK-6DknPV-Rx8QT)

## License

MIT license