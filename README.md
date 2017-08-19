# UIImageViewContrastLabel

Swift extension for UIImageView that allows to draw contrast label upon image content 

## Manual installation

Download UIImageViewContrastLabel.swift and threshold.cikernel from UIImageViewContrastLabel folder, add them to your project

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

## Demo screenshot

<img src="https://cdn.rawgit.com/bivanov/UIImageViewContrastLabel/f34e3aee/Screenshots/Scrn1.png" alt="Demo screenshot" width="50%" height="50%">
