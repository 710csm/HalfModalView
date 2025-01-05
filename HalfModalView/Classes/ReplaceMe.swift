import UIKit

open class HalfModalViewController: UIViewController {
    
    // MARK: - UI Components
    
    // main view of HalfModalViewController
    public lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // background above main view
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = backgrounAlpha
        return view
    }()
    
    // MARK: - Properties
    
    // maximum height of base view
    private let maximumBaseViewHeight: CGFloat = UIScreen.main.bounds.height - 64
    
    // default base view height
    private var defaultHeight: CGFloat = 450
    
    // height of baseView disappearance
    private var dismissibleHeight: CGFloat = 300
    
    // keep current new height, initial is default height
    private var currentBaseViewHeight: CGFloat = 450
    
    // transparency of background
    private var backgrounAlpha: CGFloat = 0.4 {
        didSet {
            backgroundView.alpha = backgrounAlpha
        }
    }
    
    // dynamic container constraint
    private var baseViewHeightConstraint: NSLayoutConstraint?
    private var baseViewBottomConstraint: NSLayoutConstraint?
    
    public var topAchor: NSLayoutYAxisAnchor {
        baseView.topAnchor
    }
    public var leadingAnchor: NSLayoutXAxisAnchor {
        baseView.leadingAnchor
    }
    public var trailingAnchor: NSLayoutXAxisAnchor {
        baseView.trailingAnchor
    }
    public var bottomAnchor: NSLayoutYAxisAnchor {
        baseView.bottomAnchor
    }
    
    public var centerXAnchor: NSLayoutXAxisAnchor {
        baseView.centerXAnchor
    }
    public var centerYAnchor: NSLayoutYAxisAnchor {
        baseView.centerYAnchor
    }
    public var center: CGPoint {
        baseView.center
    }
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupPanGesture()
    }
    
    // run animation when view appears
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beginShowBackgroundView()
        beginShowBaseView()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetBaseViewHeight()
    }
    
    // MARK: - Set View
    
    private func setupView() {
        self.view.backgroundColor = .clear
    }
    
    // set up base view and background view constraints
    public func setupConstraints() {
        // add subviews
        self.view.addSubview(backgroundView)
        self.view.addSubview(baseView)
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
    
    public func addSubview(_ view: UIView) {
        baseView.addSubview(view)
    }
    
    public func setDefaultHeight(_ hegiht: CGFloat) {
        defaultHeight = hegiht
    }
    
    public func setDismissibleHeight(_ hegiht: CGFloat) {
        dismissibleHeight = hegiht
    }
    
    public func setBackGroudViewAlpha(_ alpha: CGFloat) {
        backgrounAlpha = alpha
    }
    
    // MARK: - Set Gesture
    
    private func setupPanGesture() {
        // add tap gesture recognizer to the backgroundView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // add pan gesture recognizer to the view controller's view (the whole screen)
        // change to false to immediately listen on gesture movement
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture)
        )
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Present and dismiss animation
    
    private func updateBaseViewHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            // update baseView height
            self.baseViewHeightConstraint?.constant = height
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // save current height
        currentBaseViewHeight = height
    }
    
    private func beginShowBaseView() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.baseViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    private func beginShowBackgroundView() {
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = self.backgrounAlpha
        }
    }
    
    private func endShowBackgroundView() {
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
    
    private func resetBaseViewHeight() {
        currentBaseViewHeight = defaultHeight
        baseViewHeightConstraint?.constant = defaultHeight
        self.view.layoutIfNeeded()
    }
    
    // MARK: - objc Action
    
    @objc func handleCloseAction() {
        endShowBackgroundView()
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
                self.view.layoutIfNeeded()
            }
        case .ended:
            // this happens when user stop drag,
            // so we will get the last height of baseView
            
            // condition 1: if new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.endShowBackgroundView()
            }
            else if newHeight < defaultHeight {
                // condition 2: if new height is below default, animate back to default
                updateBaseViewHeight(defaultHeight)
            }
            else if newHeight < maximumBaseViewHeight && isDraggingDown {
                // condition 3: if new height is below max and going down, set to default height
                updateBaseViewHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // condition 4: if new height is below max and going up, set to max height at top
                updateBaseViewHeight(maximumBaseViewHeight)
            }
        default:
            break
        }
    }
}
