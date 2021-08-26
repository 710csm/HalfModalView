//
//  ViewController.swift
//  HalfModalView
//
//  Created by 최승명 on 08/26/2021.
//  Copyright (c) 2021 최승명. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func presentHalfModalView(_ sender: Any) {
        let view = HalfModalViewController()
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: false)
    }
}

