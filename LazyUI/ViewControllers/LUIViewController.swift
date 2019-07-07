//
//  LUIViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIViewController: UIViewController {

    override open func loadView() {
        self.view = LUIView()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func addView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public func center(_ view: UIView) {
        self.view.center(view)
    }
    
    public func centerX(_ view: UIView) {
        self.view.centerX(view)
    }
    
    public func centerY(_ view: UIView) {
        self.view.centerY(view)
    }

}
