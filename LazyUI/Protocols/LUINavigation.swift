//
//  LUINavigation.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public protocol LUINavigation {
    // use private stored property when adding LUINavigation
    var navigation: LUINavigationViewController? { get set }
    
    func push(to vc: UIViewController)
    func pop()
    func popToRoot()
    func present(_ vc: UIViewController)
    func presentModally(_ vc: UIViewController)
    func presentNavigation(_ vc: UIViewController)
    func popOver(_ vc: UIViewController)
    func dissmissableNavigation() -> LUINavigationViewController
    
}
