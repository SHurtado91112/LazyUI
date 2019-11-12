//
//  LUINavigationViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUINavigationViewController: UINavigationController, LUIViewControllerProtocol {

    required public init(rootVC: UIViewController, largeTitle: Bool = true) {
        super.init(rootViewController: rootVC)
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = largeTitle ? .always : .never
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open func setLargeTitleMode(_ displayMode: UINavigationItem.LargeTitleDisplayMode, for currentViewController: UIViewController) {
        switch displayMode {
            case .automatic:
                
                if let index = self.children.firstIndex(of: currentViewController) {
                    self.setLargeTitleMode(index == 0 ? .always : .never, for: currentViewController)
                } else {
                    self.setLargeTitleMode(.always, for: currentViewController)
                }
                
                break
            case .always, .never:
                self.navigationItem.largeTitleDisplayMode = displayMode
                navigationController?.navigationBar.prefersLargeTitles = true
                break
            @unknown default:
                self.setLargeTitleMode(.never, for: currentViewController)
                break
        }
    }
    
    open func push(to vc: UIViewController) {
        self.pushViewController(vc, animated: true)
    }
    
    open func forDismissal() -> LUINavigationViewController {
        // TODO: - Set up dismissing components
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissNavigation))
        return self
    }
    
    // MARK: - Adding Views and Constraints
    
    public func addView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public func centerX(_ view: UIView) {
        self.view.centerX(view)
    }
    
    public func centerY(_ view: UIView) {
        self.view.centerY(view)
    }
    
    public func center(_ view: UIView) {
        self.view.center(view)
    }
    
    public func fill(_ view: UIView, padding: LUIPaddingType = .none) {
        self.view.fill(view, padding: padding)
    }
    
    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        childController.didMove(toParent: self)
    }
    
    @objc public func dismissNavigation() {
        self.dismiss(animated: true, completion: nil)
    }
    
    open func setUpViews() {
        self.setUpNavigationView()
    }

    private func setUpNavigationView() {
        
        // MARK: - NAVIGATION PROXY
        let navigationBar = UINavigationBar.appearance()
        self.navigationBar.titleTextAttributes = navigationBar.titleTextAttributes
        self.navigationBar.titleTextAttributes?[NSAttributedString.Key.font] =  self.substituteFont.withSize(.regular).withStyle(.bold)
        
        self.navigationBar.largeTitleTextAttributes = navigationBar.largeTitleTextAttributes
        self.navigationBar.largeTitleTextAttributes?[NSAttributedString.Key.font] =  self.substituteFont.withSize(.title).withStyle(.bold)
        
        let barButton = UIBarButtonItem.appearance()
        let attributes = [
            NSAttributedString.Key.font : self.substituteFont.withSize(.regular).withStyle(.regular)
        ]
        
        barButton.setTitleTextAttributes(attributes, for: .normal)
        barButton.setTitleTextAttributes(attributes, for: .highlighted)
        barButton.setTitleTextAttributes(attributes, for: .disabled)
        barButton.setTitleTextAttributes(attributes, for: .selected)
        
    }
}

extension LUINavigationViewController: LUINavigation {
    
    public var navigation: LUINavigationViewController? {
        get {
            return self
        }
        set { }
    }
    
    public func pop() {
        self.popViewController(animated: true)
    }
    
    public func popToRoot() {
        self.popToRootViewController(animated: true)
    }
    
    public func present(_ vc: UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentModally(_ vc: UIViewController) {
        self.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentNavigation(_ vc: UIViewController) {
        let nav = LUINavigationViewController(rootVC: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        LUIPopOverViewController.current = popOver
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popOver.view)
        currentWindow?.fill(popOver.view, padding: .none)
    }
    
    public func dissmissableNavigation() -> LUINavigationViewController {
        return LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
    }
    
    
}
