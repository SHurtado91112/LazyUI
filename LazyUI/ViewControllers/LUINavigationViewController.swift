//
//  LUINavigationViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUINavigationViewController: UINavigationController {

    required public init(rootVC: UIViewController, largeTitle: Bool = true) {
        super.init(rootViewController: rootVC)
        self.navigationBar.prefersLargeTitles = largeTitle
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open func push(to vc: UIViewController) {
        self.pushViewController(vc, animated: true)
    }
    
    open func forDismissal() -> LUINavigationViewController {
        // TODO: - Set up dismissing components
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissNavigation))
        return self
    }
    
    @objc public func dismissNavigation() {
        self.dismiss(animated: true, completion: nil)
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
