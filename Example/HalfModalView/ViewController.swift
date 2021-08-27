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
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel, spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
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
        halfModal.baseView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        // set constrain based on baseView of HalfModalView
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: halfModal.baseView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: halfModal.baseView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: halfModal.baseView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: halfModal.baseView.trailingAnchor, constant: -20),
        ])
        
        self.present(halfModal, animated: false)
    }
}

