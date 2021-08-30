# HalfModalView

[![CI Status](https://img.shields.io/travis/최승명/HalfModalView.svg?style=flat)](https://travis-ci.org/최승명/HalfModalView)
[![Version](https://img.shields.io/cocoapods/v/HalfModalView.svg?style=flat)](https://cocoapods.org/pods/HalfModalView)
[![License](https://img.shields.io/cocoapods/l/HalfModalView.svg?style=flat)](https://cocoapods.org/pods/HalfModalView)
[![Platform](https://img.shields.io/cocoapods/p/HalfModalView.svg?style=flat)](https://cocoapods.org/pods/HalfModalView)

## Requirements

## Installation

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```ruby
gem install cocoapods
```

HalfModalView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'HalfModalView'
end
```

Then, run the following command:

```ruby
$ pod install
```

## Usage

```Swift
import HalfModalView

class ViewController: UIViewController {
    
    let halfModal = HalfModalViewController()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Half Modal View Test"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHalfModalView()
    }
    
    func setHalfModalView() {
        // modalPresentationStyle must set to overCurrentContext
        halfModal.modalPresentationStyle = .overCurrentContext
        
        // add to baseView of HalfModalView
        halfModal.baseView.addSubview(titleLabel)
        halfModal.baseView.addSubview(contentLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        // set constrain based on baseView of HalfModalView
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: halfModal.baseView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: halfModal.baseView.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.centerXAnchor.constraint(equalTo: halfModal.baseView.centerXAnchor)
        ])
    }

    @IBAction func presentHalfModalView(_ sender: Any) {
        self.present(halfModal, animated: false)
    }
}
```

## Author

최승명, 710csm@naver.com

## License

HalfModalView is available under the MIT license. See the LICENSE file for more info.
