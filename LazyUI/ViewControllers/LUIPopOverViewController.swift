//
//  LUIPopOverViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIPopOverViewController: LUIViewController {
    
    public var isDismissible = true
    
    lazy var contentView : LUIView = {
        let view = LUIView()
        self.addView(view)
        self.center(view)
        view.square(to: UIScreen.main.bounds.width*2.0/3.0)
        view.roundCorners(to: 16.0)
        view.addShadow()
        return view
    } ()
    
    private var contentViewController : UIViewController?
    
    public required init(contentVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.contentViewController = contentVC
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.fadeIn()
    }
    
    public func setUpViews() {
        self.view.backgroundColor = UIColor.color(for: .shadow).withAlphaComponent(0.6)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.popOverTapped))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        if let vc = self.contentViewController {
            self.contentView.addSubview(vc.view)
            self.contentView.fill(vc.view, padding: .regular)
            self.addChild(vc)
            self.contentView.alpha = 1.0
        }
    }
    
    @objc private func popOverTapped(sender: UITapGestureRecognizer) {
        if self.isDismissible {
            self.view.fadeOut {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension LUIPopOverViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view?.isDescendant(of: self.contentView) ?? false)
    }
}