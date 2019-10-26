//
//  LUIPanelViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/23/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

extension LUIPanelViewController {
    
    public enum PresentationMode: CaseIterable {
        case header
        case halfway
        case full
        
        func next() -> PresentationMode {
            switch self {
                case .header:
                    return .halfway
                case .halfway:
                    return .full
                case .full:
                    return .full
            }
        }
        
        func prev() -> PresentationMode {
            switch self {
                case .header:
                    return .header
                case .halfway:
                    return .header
                case .full:
                    return .halfway
            }
        }
    }
    
}

public protocol LUIPanelViewDelegate: LUIViewController {
    var preferredHeight: CGFloat { get set }
    func willTransition(to presentationMode: LUIPanelViewController.PresentationMode)
}

open class LUIPanelViewController: LUIViewController {
    
    open private(set) var presentationModes: [(mode: PresentationMode, height: CGFloat)] = []
    private var currentMode: PresentationMode = .header {
        didSet {
            self.lastMode = oldValue
        }
    }
    
    private var headerViewController: LUIPanelViewDelegate?
    private var halfwayViewController: LUIPanelViewDelegate?
    private var fullViewController: LUIPanelViewDelegate?
    private var containingViewController: UIViewController!

    private var lastMode: PresentationMode = .header
    private var topConstraint: NSLayoutConstraint?
    private var currentTargetHeight: CGFloat = 0.0
    private var lastTranslation: CGPoint = .zero
    
    private lazy var contentView = LUIStackView(padding: .regular)
    
    let PANEL_CORNER_RADIUS: CGFloat = 8.0
    let DRAG_BAR_HEIGHT: CGFloat = 16.0
    private lazy var dragBar: UIView = {
        let barHeight: CGFloat = self.DRAG_BAR_HEIGHT
        let indicatorHeight: CGFloat = barHeight / 4.0
        let indicatorWidth: CGFloat = 40.0
        let bar = UIView()
        bar.height(to: barHeight)
        
        let indicator = UIView()
        indicator.backgroundColor = UIColor.color(for: .border)
        bar.addSubview(indicator)
        bar.center(indicator)
        
        indicator.height(to: indicatorHeight)
        indicator.width(to: indicatorWidth, constraintOperator: .equal)
        indicator.roundCorners(to: indicatorHeight / 2.0)
        
        return bar
    } ()
    
    public required init(containingViewController: UIViewController, headerViewController: LUIPanelViewDelegate?, halfwayViewController: LUIPanelViewDelegate?, fullViewController: LUIPanelViewDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.containingViewController = containingViewController
        
        // offset padding for views that aren't full mode
        let offsetPadding = self.DRAG_BAR_HEIGHT + self.safetyTopPadding + self.safetyBottomPadding + LUIPadding.padding(for: .regular) // regular padding for content view spacing
        if let headerVC = headerViewController {
            self.headerViewController = headerVC
            self.presentationModes.append((mode: .header, height: headerVC.preferredHeight + offsetPadding))
        }
        
        if let halfwayVC = halfwayViewController {
            self.halfwayViewController = halfwayVC
            self.presentationModes.append((mode: .halfway, height: halfwayVC.preferredHeight + offsetPadding))
        }
        
        if let fullVC = fullViewController {
            self.fullViewController = fullVC
            self.presentationModes.append((mode: .full, height: self.fullScreenHeight))
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setUpViews() {
        
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor.color(for: .lightBackground)
        self.view.roundCorners(to: self.PANEL_CORNER_RADIUS) // system rounded corners?
        self.view.addShadow(offset: CGSize(width: 0.0, height: -4.0))
        
        self.addView(self.contentView)
        self.addView(self.dragBar)
        
        for (mode, _) in self.presentationModes {
            if let viewController = self.viewController(for: mode) {
                self.addChild(viewController)
                viewController.view.height(to: viewController.preferredHeight, constraintOperator: .greaterThan)
                
                if mode == .header {
                    self.addView(viewController.view)
                } else {
                    self.contentView.addArrangedSubview(contentView: viewController.view, fill: true)
                }
            }
        }

        let padding = LUIPadding.padding(for: .regular)
        self.view.top(self.dragBar, fromTop: true, paddingType: .small, withSafety: false)
        
        if let headerController = self.viewController(for: .header) {
            self.dragBar.bottom(headerController.view!, fromTop: true, paddingType: .small, withSafety: false)
            headerController.view!.bottom(self.contentView, fromTop: true, paddingType: .small, withSafety: false)
            
            self.view.left(headerController.view!, fromLeft: true, paddingType: .regular, withSafety: false)
            self.view.right(headerController.view!, fromLeft: false, paddingType: .regular, withSafety: false)
        } else {
            self.dragBar.bottom(self.contentView, fromTop: true, paddingType: .small, withSafety: false)
        }
        
        self.view.left(self.contentView, fromLeft: true, paddingType: .none, withSafety: false)
        self.view.left(self.dragBar, fromLeft: true, paddingType: .none, withSafety: false)
        
        self.view.right(self.contentView, fromLeft: false, paddingType: .none, withSafety: false)
        self.view.right(self.dragBar, fromLeft: false, paddingType: .none, withSafety: false)
        self.view.bottom(self.contentView, fromTop: false, padding: -padding, withSafety: false, constraintOperator: .equal)
        
        self.containingViewController.addChild(self)
        self.containingViewController.view.addSubview(self.view!)
        
        if let containerView = self.containingViewController.view, let panelView = self.view {
            containerView.left(panelView, fromLeft: true, paddingType: .none, withSafety: false)
            containerView.right(panelView, fromLeft: false, paddingType: .none, withSafety: false)
            
            containerView.bottom(panelView, fromTop: false, padding: -padding, withSafety: false, constraintOperator: .equal)
            self.topConstraint = containerView.top(panelView, fromTop: true, paddingType: .none, withSafety: true)
            
            // set panel position below screen
            self.topConstraint?.constant = UIScreen.main.bounds.height + padding
            containerView.layoutIfNeeded()
            
            panelView.isHidden = true
        }
        
        self.setUpGestures()
    }
    
    private func setUpGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        self.dragBar.addGestureRecognizer(panGesture)
            
    }
    
    private func nextMode(for velocity: CGPoint) -> PresentationMode {
        return velocity.y < 0 ? self.currentMode.next() : self.currentMode.prev()
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        guard let panView = recognizer.view else { return }
        let velocity = recognizer.velocity(in: panView)
        
        switch recognizer.state {
            case .began:
                self.beginHeightUpdate(for: velocity)
                break
            case .changed:
                let translation = recognizer.translation(in: panView)
                let deltaTranslation = CGPoint(x: translation.x - self.lastTranslation.x, y: translation.y - self.lastTranslation.y)
                self.updateHeight(for: velocity, currentTranslation: deltaTranslation)
                
                self.lastTranslation = translation
                break
            case .ended:
                self.endHeightUpdate()
                break
            default:
                break
        }
        
        self.updateViewPresentation()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animateIn()
    }
    
    // meant to be called once
    public func presentPanel(forMode mode: PresentationMode) {
        self.setCurrentMode(mode)
        self.animateIn()
    }
    
    private func setCurrentMode(_ mode: PresentationMode) {
        self.currentMode = mode
        self.notifyDelegates(for: mode)
    }
    
    private func animateIn() {
        guard let panelView = self.view, let containerView = self.containingViewController.view else { return }
        
        // animate panel view to appear
        panelView.alpha = 0.0
        panelView.isHidden = false
        panelView.isUserInteractionEnabled = false
        
        let initialPosition = self.currentTopOffset
        self.topConstraint?.constant = initialPosition
        
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), delay: 0.0, options: .curveEaseInOut, animations: {
            
            panelView.alpha = 1.0
            containerView.layoutIfNeeded()
            
        }) { (finished) in
            panelView.isUserInteractionEnabled = true
        }
    }
    
    private func checkForFinalViewUpdates() {
        
        if let _ = self.viewController(for: .header)?.view {
            // constant for internal updates
        }
        
        if let halfwayView = self.viewController(for: .halfway)?.view {
            let showMe = self.currentMode != .header
            halfwayView.isUserInteractionEnabled = showMe
            halfwayView.alpha = showMe ? 1.0 : 0.0
            halfwayView.isHidden = !showMe
        }
        
        if let fullView = self.viewController(for: .full)?.view {
            let showMe = self.currentMode == .full
            fullView.isUserInteractionEnabled = showMe
            fullView.alpha = showMe ? 1.0 : 0.0
            fullView.isHidden = !showMe
        }
        
    }
    
    private func updateViewPresentation() {
        
        // all view are updated internally, but can be manipulated externally through LUIPanelViewDelegate method
        for (mode, _) in self.presentationModes {
            let viewForMode = self.viewController(for: mode)?.view
            self.contentView.isUserInteractionEnabled = self.currentMode != .header
            
            let animationTime = TimeInterval.timeInterval(for: .fast).miliseconds
            switch mode {
                case .header:
                    // header view stays constant internally
                    break
                case .halfway:
                    
                    viewForMode?.isUserInteractionEnabled = self.currentMode != .header
                    if self.currentMode == .header {
                        viewForMode?.fadeOut()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(animationTime)) {
                            viewForMode?.isHidden = true
                            
                            // check after async call to finalize view updates
                            self.checkForFinalViewUpdates()
                        }
                    } else {
                        viewForMode?.isHidden = false
                        viewForMode?.fadeIn()
                    }
                    break
                case .full:
                    viewForMode?.isUserInteractionEnabled = self.currentMode == .full
                    if self.currentMode != .full {
                        viewForMode?.fadeOut()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(animationTime)) {
                            viewForMode?.isHidden = true
                            
                            // check after async call to finalize view updates
                            self.checkForFinalViewUpdates()
                        }
                    } else {
                        viewForMode?.isHidden = false
                        viewForMode?.fadeIn()
                    }
                    break
            }
        }
        
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func notifyDelegates(for transitionMode: PresentationMode) {
        
        for (mode, _) in self.presentationModes {
            self.viewController(for: mode)?.willTransition(to: transitionMode)
        }
        
    }

    private func viewController(for mode: PresentationMode) -> LUIPanelViewDelegate? {
        switch mode {
            case .header:
                return self.headerViewController
            case .halfway:
                return self.halfwayViewController
            case .full:
                return self.fullViewController
        }
    }
    
    private var safetyTopPadding: CGFloat {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.top ?? .zero
    }
    
    private var safetyBottomPadding: CGFloat {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.bottom ?? 0.0
    }
    
    private var fullScreenHeight: CGFloat {
        return UIScreen.main.bounds.height - self.safetyTopPadding
    }
    
    private var currentTopOffset: CGFloat {
        let currentHeight = self.presentationModes.first { (arg0) -> Bool in
            let (mode, _) = arg0
            return mode == self.currentMode
        }?.height ?? .zero
        
        return self.fullScreenHeight - currentHeight
    }
    
    private var lastTopOffset: CGFloat {
        let lastHeight = self.presentationModes.first { (arg0) -> Bool in
            let (mode, _) = arg0
            return mode == self.lastMode
        }?.height ?? .zero
        
        return self.fullScreenHeight - lastHeight
    }
    
    private func beginHeightUpdate(for velocity: CGPoint) {
        
        let nextMode = self.nextMode(for: velocity)
        let nextHeight = self.presentationModes.first { (arg0) -> Bool in
            let (mode, _) = arg0
            return mode == nextMode
        }?.height ?? .zero
        
        self.topConstraint?.constant = self.currentTopOffset
        
        self.setCurrentMode(nextMode)
        self.currentTargetHeight = nextHeight
        
    }
    
    private func updateHeight(for velocity: CGPoint, currentTranslation: CGPoint) {
       
        let targetTopOffset = self.fullScreenHeight - self.currentTargetHeight
        let nextTopOffset = (self.topConstraint?.constant ?? .zero) + currentTranslation.y
        
        if velocity.y < 0 { // up
            
            if nextTopOffset < targetTopOffset { // update new mode
                self.beginHeightUpdate(for: velocity)
            }
            
        } else if velocity.y > 0 { // down
            
            if nextTopOffset > targetTopOffset { // update new mode
                self.beginHeightUpdate(for: velocity)
            }
            
        }
        
        self.topConstraint?.constant = nextTopOffset
    }
    
    private func endHeightUpdate() {
        
        let targetTopOffset = self.fullScreenHeight - self.currentTargetHeight
        let lastTopOffset = self.lastTopOffset
        let endingTopOffset = (self.topConstraint?.constant ?? .zero)
        
        let deltaTarget = abs(targetTopOffset - endingTopOffset)
        let deltaCurrent = abs(lastTopOffset - endingTopOffset)
        
        if deltaTarget < deltaCurrent { // set height to target
            self.topConstraint?.constant = targetTopOffset
        } else { // set height to current
            self.topConstraint?.constant = lastTopOffset
            self.setCurrentMode(self.lastMode)
        }
        
        self.lastTranslation = CGPoint.zero
        
    }
    
}

extension LUIPanelViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: self.view)
            
            return abs(velocity.x) < abs(velocity.y) // only detect vertical pans
        }
        
        return false
    }
    
}
