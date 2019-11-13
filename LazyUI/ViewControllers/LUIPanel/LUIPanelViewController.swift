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

public protocol LUIPanelViewDelegate: UIViewController {
    var preferredHeight: CGFloat { get set }
    func willTransition(to presentationMode: LUIPanelViewController.PresentationMode, from panelViewController: LUIPanelViewController)
}

public typealias PresentationModeInfo = (mode: LUIPanelViewController.PresentationMode, height: CGFloat)

open class LUIPanelViewController: LUIViewController {
    
    open var enabledPresentationModes: [PresentationMode] = [] {
        didSet {
            self.enabledModesInfo = self.presentationModes.filter({ return self.enabledPresentationModes.contains($0.mode) })
        }
    }
    private var enabledModesInfo: [PresentationModeInfo] = []
    private var presentationModes: [PresentationModeInfo] = []
    private var currentMode: PresentationModeInfo = (mode: .header, height: 0.0) {
        didSet {
            self.lastMode = oldValue
        }
    }
    
    private var headerViewController: LUIPanelViewDelegate?
    private var halfwayViewController: LUIPanelViewDelegate?
    private var fullViewController: LUIPanelViewDelegate?
    private var additionalDelegates: [LUIPanelViewDelegate] = []
    private var containingViewController: UIViewController!

    private var lastMode: PresentationModeInfo = (mode: .header, height: 0.0)
    private var topConstraint: NSLayoutConstraint?
    private var currentTargetHeight: CGFloat = 0.0
    private var lastTranslation: CGPoint = .zero
    private var heightConstraintMap: [PresentationMode: NSLayoutConstraint] = [:]
    
    private lazy var contentView = LUIStackView(padding: .regular)
    
    let PANEL_CORNER_RADIUS: CGFloat = 8.0
    let DRAG_BAR_HEIGHT: CGFloat = 12.0
    private lazy var dragBar: UIView = {
        let barHeight: CGFloat = self.DRAG_BAR_HEIGHT
        let indicatorHeight: CGFloat = barHeight / 3.0
        let indicatorWidth: CGFloat = 40.0
        let bar = UIView()
        bar.setContentHuggingPriority(.required, for: .vertical)
        bar.height(to: barHeight)
        
        let indicator = UIView()
        indicator.backgroundColor = UIColor.color(for: .border)
        bar.addSubview(indicator)
        bar.centerX(indicator)
        bar.top(indicator, fromTop: true, padding: 4.0, withSafety: false, constraintOperator: .equal)
        
        indicator.height(to: indicatorHeight)
        indicator.width(to: indicatorWidth, constraintOperator: .equal)
        indicator.roundCorners(to: indicatorHeight / 2.0)
        
        return bar
    } ()
    
    private var safetyTopPadding: CGFloat {
        let window = UIApplication.shared.keyWindow
        return (window?.safeAreaInsets.top ?? .zero) + self.largePadding
    }
    
    private var safetyBottomPadding: CGFloat {
        let window = UIApplication.shared.keyWindow
        return (window?.safeAreaInsets.top ?? .zero)
    }
    
    private var safetyFullScreenHeight: CGFloat {
        return UIScreen.main.bounds.height - self.safetyTopPadding
    }
    private var fullScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    private var compactModeHeightOffset: CGFloat {
        // regular padding for content view spacing
        return self.safetyBottomPadding + self.padding
    }
    
    private var currentTopOffset: CGFloat {
        let currentHeight = self.currentMode.height
        
        if self.currentMode.mode == .full {
            return self.safetyTopPadding
        } else {
            return self.fullScreenHeight - currentHeight
        }
    }
    
    private var lastTopOffset: CGFloat {
        
        let lastHeight = self.lastMode.height
        
        if self.lastMode.mode == .full {
            return self.safetyTopPadding
        } else {
            return self.fullScreenHeight - lastHeight
        }
        
    }
    
    private var padding: CGFloat {
        return LUIPadding.padding(for: .regular) + self.DRAG_BAR_HEIGHT
    }
    
    private var largePadding: CGFloat {
           return LUIPadding.padding(for: .large) + self.DRAG_BAR_HEIGHT
   }
    
    public required init(containingViewController: UIViewController, headerViewController: LUIPanelViewDelegate?, halfwayViewController: LUIPanelViewDelegate?, fullViewController: LUIPanelViewDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.containingViewController = containingViewController
        
        // offset padding for views that aren't full mode
        let offsetPadding = self.compactModeHeightOffset
            
        if let headerVC = headerViewController {
            self.headerViewController = headerVC
            self.presentationModes.append((mode: .header, height: headerVC.preferredHeight + offsetPadding))
        }
        
        if let halfwayVC = halfwayViewController {
            self.halfwayViewController = halfwayVC
            let heightForHeader = self.viewController(for: .header)?.preferredHeight ?? 0.0
            self.presentationModes.append((mode: .halfway, height: halfwayVC.preferredHeight + heightForHeader + offsetPadding))
        }
        
        if let fullVC = fullViewController {
            self.fullViewController = fullVC
            self.presentationModes.append((mode: .full, height: self.safetyFullScreenHeight))
        }
        
        self.enabledModesInfo = self.presentationModes
        self.enabledModesInfo.enumerated().forEach({
            let element = $0.1
            self.enabledPresentationModes.append(element.mode)
        })
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setUpViews() {
        
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor.color(for: .lightBackground)
        self.view.roundCorners(to: self.PANEL_CORNER_RADIUS) // system rounded corners?
        self.view.addShadow(offset: CGSize(width: 0.0, height: -4.0))
        
        // background blocker view
        let blockerView = UIView()
        blockerView.backgroundColor = self.view.backgroundColor
        blockerView.width(to: UIScreen.main.bounds.width)
        blockerView.height(to: self.fullScreenHeight / 2.0) // overflow to ensure proper blockage
        
        self.addView(blockerView)
        self.view.centerX(blockerView)
        self.view.bottom(blockerView, fromTop: true, paddingType: .none, withSafety: false, constraintOperator: .equal)
        
        self.addView(self.contentView)
        self.addView(self.dragBar)
        
        for (mode, _) in self.presentationModes {
            if let viewController = self.viewController(for: mode) {
                self.addChild(viewController)
                
                self.updateHeightConstraintMap(viewController.view.height(to: viewController.preferredHeight, constraintOperator: .greaterThan), mode: mode)
                
                if mode == .header {
                    self.addView(viewController.view)
                } else {
                    self.contentView.addArrangedSubview(contentView: viewController.view, fill: true)
                }
            }
        }

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

        self.contentView.bottom(self.view, fromTop: false, paddingType: .none, withSafety: false, constraintOperator: .equal)
        
        self.containingViewController.addChild(self)
        self.containingViewController.view.addSubview(self.view!)
        
        if let containerView = self.containingViewController.view, let panelView = self.view {
            containerView.left(panelView, fromLeft: true, paddingType: .none, withSafety: false)
            containerView.right(panelView, fromLeft: false, paddingType: .none, withSafety: false)
            
            containerView.bottom(panelView, fromTop: false, paddingType: .none, withSafety: false, constraintOperator: .equal)
            self.topConstraint = containerView.top(panelView, fromTop: true, paddingType: .none, withSafety: false)
            
            // set panel position below screen
            self.topConstraint?.constant = self.fullScreenHeight// + padding
            containerView.layoutIfNeeded()
            
            panelView.isHidden = true
        }
        
        self.setUpGestures()
    }
    
    public func setMode(_ mode: PresentationMode) {
        
        // get mode info
        if let modeInfo = self.enabledModesInfo.first(where: { $0.mode == mode }) {
            
            self.setCurrentMode(modeInfo)
            self.topConstraint?.constant = self.currentTopOffset
            self.updateViewPresentation()
        }
        
    }
    
    public func addDelegate(_ delegate: LUIPanelViewDelegate) {
        self.additionalDelegates.append(delegate)
    }
    
    public func adjustPreferredHeight(_ height: CGFloat, for mode: PresentationMode) {
        
        guard mode != .full else { return }
        
        if let viewController = self.viewController(for: mode) {

            for i in 0..<self.presentationModes.count {
                let modeInfo = self.presentationModes[i]
                if modeInfo.mode == mode {
                    
                    var heightWithOffset: CGFloat = 0.0
                    heightWithOffset = self.compactModeHeightOffset + height
                    
                    if mode == .halfway {
                        let heightForHeader = self.viewController(for: .header)?.preferredHeight ?? 0.0
                        heightWithOffset += heightForHeader
                    }
                    
                    self.presentationModes[i].height = heightWithOffset
                    break
                }
            }
            
            // updates any currently enabled presentation modes
            self.enabledModesInfo = self.presentationModes
            self.enabledPresentationModes = { self.enabledPresentationModes } ()
            
            self.updateHeightConstraintMap(viewController.view.height(to: viewController.preferredHeight, constraintOperator: .equal), mode: mode)
            
            
            if mode == self.currentMode.mode {
                self.setMode(mode) // update view if current mode
            }
        }
    }
    
    private func updateHeightConstraintMap(_ constraint: NSLayoutConstraint, mode: PresentationMode) {
        // eliminate previous constraint
        self.heightConstraintMap[mode]?.eliminate()

        // apply new constraint
        self.heightConstraintMap[mode] = constraint
        
    }
    
    private func setUpGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        self.view.addGestureRecognizer(panGesture)
            
    }
    
    private func nextMode(for velocity: CGPoint) -> PresentationModeInfo {
        if velocity.y < 0  {
            var nextMode: PresentationMode = self.currentMode.mode
            repeat {
                nextMode = nextMode.next()
            } while(!self.enabledPresentationModes.contains(nextMode) && nextMode != .full)
            
            if let nextModeInfo = self.enabledModesInfo.first(where: { $0.mode == nextMode}) {
                return nextModeInfo
            } else {
                return self.currentMode
            }
        } else {
            var prevMode: PresentationMode = self.currentMode.mode
            repeat {
                prevMode = prevMode.prev()
            } while(!self.enabledPresentationModes.contains(prevMode) && prevMode != .header)
            
            if let prevModeInfo = self.enabledModesInfo.first(where: { $0.mode == prevMode}) {
                return prevModeInfo
            } else {
                return self.currentMode
            }
        }
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        guard let panView = recognizer.view else { return }
        let velocity = recognizer.velocity(in: panView)
        
        if panView != self.view && panView != self.dragBar {
            return
        }
        
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
    
    open private(set) var isAnimating: Bool = false
    // meant to be called once
    public func presentPanel(forMode mode: PresentationMode) {
        if let modeInfo = self.enabledModesInfo.first(where: { $0.mode == mode }) {
            self.setCurrentMode(modeInfo)
            self.animateIn()
        }
    }
    
    public func hidePanel() {
        self.animateOut()
    }
    
    private func setCurrentMode(_ modeInfo: PresentationModeInfo) {
        self.currentMode = modeInfo
        self.notifyDelegates(for: modeInfo.mode)
    }
    
    private func animateIn() {
        guard let panelView = self.view, let containerView = self.containingViewController.view else { return }
        
        // animate panel view to appear
        panelView.alpha = 0.0
        panelView.isHidden = false
        panelView.isUserInteractionEnabled = false
        
        let speed = TimeInterval.timeInterval(for: .fast)
        self.isAnimating = true
        
        let initialPosition = self.currentTopOffset
        self.topConstraint?.constant = initialPosition
        
        UIView.animate(withDuration: speed, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            panelView.alpha = 1.0
            containerView.layoutIfNeeded()
            
        }) { (finished) in
            panelView.isUserInteractionEnabled = true
            self.isAnimating = false
        }
    }
    
    private func animateOut() {
        guard let panelView = self.view, let containerView = self.containingViewController.view else { return }
        
        // animate panel view to disappear
        panelView.alpha = 1.0
        panelView.isHidden = false
        panelView.isUserInteractionEnabled = false
        
        let speed = TimeInterval.timeInterval(for: .fast)
        self.isAnimating = true
        
        self.topConstraint?.constant = UIScreen.main.bounds.height + LUIPadding.padding(for: .regular)
        
        UIView.animate(withDuration: speed, delay: 0.0, options: .curveEaseInOut, animations: {
            
            panelView.alpha = 0.0
            containerView.layoutIfNeeded()
            
        }) { (finished) in
            panelView.isUserInteractionEnabled = true
            panelView.isHidden = true
            self.isAnimating = false
        }
    }
    
    
    private func checkForFinalViewUpdates() {
        
        if let _ = self.viewController(for: .header)?.view {
            // constant for internal updates
        }
        
        if let halfwayView = self.viewController(for: .halfway)?.view {
            let showMe = self.currentMode.mode != .header && self.enabledPresentationModes.contains(.halfway)
            halfwayView.isUserInteractionEnabled = showMe
            halfwayView.alpha = showMe ? 1.0 : 0.0
            halfwayView.isHidden = !showMe
        }
        
        if let fullView = self.viewController(for: .full)?.view {
            let showMe = self.currentMode.mode == .full && self.enabledPresentationModes.contains(.full)
            fullView.isUserInteractionEnabled = showMe
            fullView.alpha = showMe ? 1.0 : 0.0
            fullView.isHidden = !showMe
        }
        
    }
    
    private func updateViewPresentation() {
        
        // all view are updated internally, but can be manipulated externally through LUIPanelViewDelegate method
        for (mode, _) in self.presentationModes {
            let viewForMode = self.viewController(for: mode)?.view
            self.contentView.isUserInteractionEnabled = self.currentMode.mode != .header
            
            let animationTime = TimeInterval.timeInterval(for: .fast).miliseconds
            switch mode {
                case .header:
                    // header view stays constant internally
                    break
                case .halfway:
                    
                    viewForMode?.isUserInteractionEnabled = self.currentMode.mode != .header
                    if self.currentMode.mode == .header {
                        viewForMode?.fadeOut()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(animationTime)) {
                            viewForMode?.isHidden = true
                            
                            // check after async call to finalize view updates
                            self.checkForFinalViewUpdates()
                        }
                    } else {
                        viewForMode?.isHidden = !self.enabledPresentationModes.contains(.halfway)
                        viewForMode?.fadeIn()
                    }
                    break
                case .full:
                    viewForMode?.isUserInteractionEnabled = self.currentMode.mode == .full
                    if self.currentMode.mode != .full {
                        viewForMode?.fadeOut()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(animationTime)) {
                            viewForMode?.isHidden = true
                            
                            // check after async call to finalize view updates
                            self.checkForFinalViewUpdates()
                        }
                    } else {
                        viewForMode?.isHidden = !self.enabledPresentationModes.contains(.full)
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
            self.viewController(for: mode)?.willTransition(to: transitionMode, from: self)
        }
        
        for delegate in self.additionalDelegates {
            delegate.willTransition(to: transitionMode, from: self)
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
    
    private func beginHeightUpdate(for velocity: CGPoint) {
        
        let nextModeInfo = self.nextMode(for: velocity)
        let nextHeight = nextModeInfo.height
        
        self.topConstraint?.constant = self.currentTopOffset
        
        self.setCurrentMode(nextModeInfo)
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
