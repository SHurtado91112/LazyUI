//
//  LUIPreviewViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class LUIPreviewViewController: LUIViewController {
    
    // open/public
    public var index: Int = -1
    public var selectedContent: LUIPreviewContent? {
        didSet {
            if let content = self.selectedContent {
                self.previewView.content = content
            }
        }
    }
    
    // private
    private let MIN_ZOOM_SCALE : CGFloat = 1.0
    private let MAX_ZOOM_SCALE : CGFloat = 6.0
    
    private let previewView = LUIPreviewView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.minimumZoomScale = self.MIN_ZOOM_SCALE
        scrollView.maximumZoomScale = self.MAX_ZOOM_SCALE
        scrollView.delegate = self
        
        return scrollView
    } ()
    
    // open/public
    public func setUpViews() {
        self.view.backgroundColor = UIColor.color(for: .darkBackground)
        
        self.addView(self.scrollView)
        self.fill(self.scrollView)
        self.scrollView.addSubview(self.previewView)
        
        self.scrollView.contentOffset = CGPoint.zero
        self.scrollView.contentSize = self.previewView.bounds.size
        
        self.setUpGestures()
    }
    
    // private
    
    private func setUpGestures() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestured))
        doubleTapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func doubleTapGestured(gesture: UIGestureRecognizer) {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale/2, animated: true)
        }
    }
}

extension LUIPreviewViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.previewView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    }
    
}

public protocol LUIPreviewDelegate {
    func pageChanged()
}

open class LUIPreviewManagerViewController: UIPageViewController, LUIViewControllerProtocol {
    
    public var previewDelegate : LUIPreviewDelegate?
    public var currentPage : Int = 0 {
        didSet {
            self.countLabel.text = "\(self.currentPage+1)/\(self.previewContent.count)"
            self.previewDelegate?.pageChanged()
            
            self.view.bringSubviewToFront(self.countLabel)
        }
    }
    
    private var _navigation: LUINavigationViewController?
    private var componentController : LUIPreviewViewController?
    
    // transitional state
    private var pendingFromController : LUIPreviewViewController?
    private var pendingToController : LUIPreviewViewController?
    
    private let countLabel : LUILabel = {
        let label = LUILabel(color: .lightText, fontSize: .regular, fontStyle: .regular)
        return label
    } ()
    
    public var previewContent: [LUIPreviewContent] = [] {
        didSet {
            self.countLabel.text = "\(self.currentPage+1)/\(self.previewContent.count)"
            self.countLabel.isHidden = self.previewContent.count <= 1
        }
    }
    
    override open func viewDidLoad() {
        self.setUpViews()
    }
    
    open func setUpViews() {
        self.setController()

        self.delegate = self
        self.dataSource = self

        self.view.addSubview(self.countLabel)
        self.view.right(self.countLabel, fromLeft: false, paddingType: .regular, withSafety: false)
        self.view.bottom(self.countLabel, fromTop: false, paddingType: .regular, withSafety: false)
    }
    
    private func setController() {
        if let viewController = self.previewController(self.currentPage) {
            self.componentController = viewController
            self.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func previewController(_ index: Int) -> LUIPreviewViewController? {
        let previewController = LUIPreviewViewController()
        previewController.index = index
        previewController.selectedContent = self.previewContent[index]
        return previewController
    }
    
}

extension LUIPreviewManagerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? LUIPreviewViewController, viewController.index > 0 {
            return self.previewController(viewController.index - 1)
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? LUIPreviewViewController, (viewController.index + 1) < self.previewContent.count {
            return self.previewController(viewController.index + 1)
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers[0] as? LUIPreviewViewController {
            self.pendingToController = viewController
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let previousController = previousViewControllers[0] as? LUIPreviewViewController {
            self.pendingFromController = previousController
        }
        
        if completed, let controller = self.pendingToController, let prev = self.pendingFromController, controller != prev {
            self.currentPage = controller.index
        }
    }
}

extension LUIPreviewManagerViewController: LUINavigation {
    
    // MARK: - Navigation
    public var navigation: LUINavigationViewController? {
        get {
            return self._navigation
        }
        set(newValue) {
            self._navigation = newValue
        }
    }
    
    public func push(to vc: UIViewController) {
        if let navigation = self.navigation {
            navigation.push(to: vc)
        } else {
            self.present(LUINavigationViewController(rootVC: vc))
        }
    }
    
    public func pop() {
        if let navigation = self.navigation {
            navigation.popViewController(animated: true)
        }
    }
    
    public func popToRoot() {
        if let navigation = self.navigation {
            navigation.popToRootViewController(animated: true)
        }
    }
    
    public func present(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        self.addChild(popOver)
        self.view.addSubview(popOver.view)
        self.view.fill(popOver.view, padding: .none)
    }
    
    public func dismissableModalViewController() -> LUINavigationViewController {
        return LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
    }
}
