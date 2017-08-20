# UIImageViewContrastLabel

Swift extension for UIImageView that allows to draw contrast label upon image content 

## Manual installation

Download UIImageViewContrastLabel.swift and threshold.cikernel from UIImageViewContrastLabel folder, add them to your project.

Change `let bundle = Bundle(identifier: "bivanov.UIImageViewContrastLabel")!` to whatever bundle you're using in UIImageViewContrastLabel.swift

## Carthage installation

Add `github "bivanov/UIImageViewContrastLabel"` to your Cartfile

## Usage 

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
let point = CGPoint(x: 0.2, y: 0.5)
        
imageView.addContrastLabel(text: text, font: font, position: point)
```

## Demo screenshot

<img src="https://cdn.rawgit.com/bivanov/UIImageViewContrastLabel/f34e3aee/Screenshots/Scrn1.png" alt="Demo screenshot 1" width="40%" height="40%"> <img src="https://cdn.rawgit.com/bivanov/UIImageViewContrastLabel/9d09fb1d/Screenshots/Scrn2.png" alt="Demo screenshot 2" width="40%" height="40%">

Demo image by [Katie Walker](https://www.flickr.com/photos/eilonwy77/9156784796/in/photolist-eX9V6W-4CugZT-6SaDQd-6JVfBq-o4HmKv-csUF5y-6ch3Yr-8gqyVs-8xY799-8gnqwK-89JCVc-89MUh1-nC5dLZ-3jHvV2-qseZKc-8xXWnu-6UNCRr-bTvNxK-8gnhwv-4nzMev-nFcAP-6PFSvP-aa2ypi-6hH4cT-e5zsAu-8vpBDL-g5BND-cA2i8m-Jh6Vr-aswLN5-6AE2po-8RuEMv-847bCY-7nKn9m-98Va1C-haGvas-amzQHW-9guVqe-dgUSwH-bX92t5-5d8zh4-9gouWH-5px1t-RvJ15n-6LUTvB-847bNU-qVd4i1-6ZqjKK-6DknPV-Rx8QT)

## License

MIT license