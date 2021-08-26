//
//  HalfModalViewController.swift
//  HalfModalView_Example
//
//  Created by 최승명 on 2021/08/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class HalfModalViewController: UIViewController {
    
    // MARK: - Properties
    public lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    public let backgrounAlpha: CGFloat = 0.4
    public lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = backgrounAlpha
        return view
    }()
    
    // Constants
    private let defaultHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 200
    private let maximumBaseViewHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    private var currentBaseViewHeight: CGFloat = 300
    
    // Dynamic container constraint
    private var baseViewHeightConstraint: NSLayoutConstraint?
    private var baseViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints ()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: - Set View
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        // Add subviews
        view.addSubview(backgroundView)
        view.addSubview(baseView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // set baseView static constraint (trailing & leading)
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Set dynamic constraints
        // First, set default height of baseView
        // after panning, the height can expand
        baseViewHeightConstraint = baseView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the baseView will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        baseViewBottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        // Activate constraints
        baseViewHeightConstraint?.isActive = true
        baseViewBottomConstraint?.isActive = true
    }
    
    // MARK: - Set Gesture
    private func setupPanGesture() {
        // add tap gesture recognizer to the backgroundView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // add pan gesture recognizer to the view controller's view (the whole screen)
        // change to false to immediately listen on gesture movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Present and dismiss animation
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            // Update baseView height
            self.baseViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentBaseViewHeight = height
    }
    
    private func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.baseViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = self.backgrounAlpha
        }
    }
    
    private func animateDismissView() {
        // hide blur view
        backgroundView.alpha = backgrounAlpha
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.baseViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - objc Action
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentBaseViewHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumBaseViewHeight {
                // Keep updating the height constraint
                baseViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of baseView
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumBaseViewHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumBaseViewHeight)
            }
        default:
            break
        }
    }

}
