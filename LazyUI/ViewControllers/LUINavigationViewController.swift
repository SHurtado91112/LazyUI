//
//  LUINavigationViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUINavigationViewController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open func push(to vc: UIViewController) {
        self.pushViewController(vc, animated: true)
    }

}
