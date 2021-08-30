//
//  ViewController.swift
//  HalfModalView
//
//  Created by 최승명 on 08/26/2021.
//  Copyright (c) 2021 최승명. All rights reserved.
//

import UIKit

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

