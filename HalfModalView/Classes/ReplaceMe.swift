import UIKit

open class HalfModalViewController: UIViewController {
    
    // MARK: - Properties
    
    // main view of HalfModalViewController
    public lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // transparency of background
    public let backgrounAlpha: CGFloat = 0.4
    
    // background above main view
    public lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = backgrounAlpha
        return view
    }()
    
    // default base view height
    public let defaultHeight: CGFloat = 300
    
    // height of baseView disappearance
    public let dismissibleHeight: CGFloat = 200
    
    // maximum height of base view
    public let maximumBaseViewHeight: CGFloat = UIScreen.main.bounds.height - 64
    
    // keep current new height, initial is default height
    public var currentBaseViewHeight: CGFloat = 300
    
    // dynamic container constraint
    private var baseViewHeightConstraint: NSLayoutConstraint?
    private var baseViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Override Method
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints ()
        setupPanGesture()
    }
    
    // run animation when view appears
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowBackgroundView()
        animatePresentBaseView()
    }
    
    // MARK: - Set View
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    // set up base view and background view constraints
    public func setupConstraints() {
        // add subviews
        view.addSubview(backgroundView)
        view.addSubview(baseView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        // set static constraints
        NSLayoutConstraint.activate([
            // set backgroundView edges to superview
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // set baseView static constraint (trailing & leading)
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // set dynamic constraints
        // first, set default height of baseView
        // after panning, the height can expand
        baseViewHeightConstraint = baseView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // by setting the height to default height, the baseView will be hide below the bottom anchor view
        // later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        baseViewBottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        // activate constraints
        baseViewHeightConstraint?.isActive = true
        baseViewBottomConstraint?.isActive = true
    }
    
    // MARK: - Set Gesture
    public func setupPanGesture() {
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
    public func animateBaseViewHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            // update baseView height
            self.baseViewHeightConstraint?.constant = height
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // save current height
        currentBaseViewHeight = height
    }
    
    public func animatePresentBaseView() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.baseViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    public func animateShowBackgroundView() {
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = self.backgrounAlpha
        }
    }
    
    public func animateBackgroundView() {
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
        animateBackgroundView()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        // drag to top will be minus value and vice versa
        let translation = gesture.translation(in: view)
        
        // get drag direction
        let isDraggingDown = translation.y > 0
        
        // new height is based on value of dragging plus current container height
        let newHeight = currentBaseViewHeight - translation.y
        
        // handle based on gesture state
        switch gesture.state {
        case .changed:
            // this state will occur when user is dragging
            if newHeight < maximumBaseViewHeight {
                // keep updating the height constraint
                baseViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // this happens when user stop drag,
            // so we will get the last height of baseView
            
            // condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateBackgroundView()
            }
            else if newHeight < defaultHeight {
                // condition 2: If new height is below default, animate back to default
                animateBaseViewHeight(defaultHeight)
            }
            else if newHeight < maximumBaseViewHeight && isDraggingDown {
                // condition 3: If new height is below max and going down, set to default height
                animateBaseViewHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // condition 4: If new height is below max and going up, set to max height at top
                animateBaseViewHeight(maximumBaseViewHeight)
            }
        default:
            break
        }
    }

}
