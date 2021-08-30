//
//  ViewController.swift
//  HalfModalView
//
//  Created by 최승명 on 08/26/2021.
//  Copyright (c) 2021 최승명. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get Started"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem fringilla ut morbi tincidunt augue interdum. \n\nUt morbi tincidunt augue interdum velit euismod in pellentesque massa. Pulvinar etiam non quam lacus suspendisse faucibus interdum posuere. Mi in nulla posuere sollicitudin aliquam ultrices sagittis orci a. Eget nullam non nisi est sit amet. Odio pellentesque diam volutpat commodo. Id eu nisl nunc mi ipsum faucibus vitae.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem fringilla ut morbi tincidunt augue interdum. Ut morbi tincidunt augue interdum velit euismod in pellentesque massa."
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func presentHalfModalView(_ sender: Any) {
        let halfModal = HalfModalViewController()
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
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 10),
            contentLabel.centerXAnchor.constraint(equalTo: halfModal.baseView.centerXAnchor)
        ])
        
        self.present(halfModal, animated: false)
    }
}

