//
//  LUIPageViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/29/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUIPageViewControllerDelegate {
    func pagingAllowed() -> Bool
    func pageChanged()
}

open class LUIPageViewController: UIPageViewController {

    // public
    public var currentPage : Int = 0
    public var pages: [UIView] = []
    public var pageDelegate: LUIPageViewControllerDelegate?
    
    public var doubleTapForPaging: Bool = false {
        didSet {
            if self.doubleTapForPaging {
                self.setDoubleTapGesture()
            }
        }
    }
    
    // transitional state
    private var pendingFromController : UIViewController?
    private var pendingToController : UIViewController?
    private var componentController : UIViewController?
    private var cachedControllers: [Int : UIViewController] = [:]
    
    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func viewDidLoad() {
        self.setUpViews()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setController()
    }
    
    open func setUpViews() {
        
    }
    
    open func nextPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        
        self.delegate?.pageViewController?(self, willTransitionTo: [nextViewController])
        
        
        self.setViewControllers([nextViewController], direction: .forward, animated: true) { (finished) in
            DispatchQueue.main.async {
                self.delegate?.pageViewController?(self, didFinishAnimating: finished, previousViewControllers: [currentViewController], transitionCompleted: finished)
            }
        }
    }
    
    open func prevPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
        
        self.delegate?.pageViewController?(self, willTransitionTo: [previousViewController])
        
        self.setViewControllers([previousViewController], direction: .reverse, animated: true) {
            (finished) in
            DispatchQueue.main.async {   
                self.delegate?.pageViewController?(self, didFinishAnimating: finished, previousViewControllers: [currentViewController], transitionCompleted: finished)
            }
        }
    }
    
    private func setDoubleTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.receivedDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func receivedDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: self.view)
        
        let leftSideArea = self.view.frame.width / 3.0 + self.view.frame.origin.x
        let rightSideArea = leftSideArea + self.view.frame.width / 3.0
        
        if touchPoint.x < leftSideArea {
            
            // double tap on the left side
            self.prevPage()
            
        } else if touchPoint.x > rightSideArea {
            
            // double on the right side
            self.nextPage()
        }
    }
    
    private func setController() {
        if let viewController = self.viewController(self.currentPage) {
            self.componentController = viewController
            self.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    public func setViewController(_ controller: UIViewController, for index: Int) {
        self.cachedControllers[index] = controller
        controller.view.tag = index
    }
    
    private func viewController(_ index: Int) -> UIViewController? {
        
        if let controller = self.cachedControllers[index] {
            return controller
        } else {
            let controller = UIViewController()
            let page = self.pages[index]
            page.removeFromSuperview()
            
            controller.view = page
            controller.view.tag = index
            
            self.cachedControllers[index] = controller
            
            return controller
        }
    }
    
}

extension LUIPageViewController: UIGestureRecognizerDelegate {
    
}

extension LUIPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        if index > 0 {
            return self.viewController(index - 1)
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        if (index + 1) < self.pages.count, self.pageDelegate?.pagingAllowed() ?? false {
            return self.viewController(index + 1)
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingToController = pendingViewControllers[0]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pendingFromController = previousViewControllers[0]
        
        if completed, let controller = self.pendingToController, let prev = self.pendingFromController, controller != prev {
            self.currentPage = controller.view.tag
            self.pageDelegate?.pageChanged()
        }
    }
}
