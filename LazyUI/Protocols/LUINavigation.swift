//
//  LUINavigation.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public protocol LUINavigation {
    public var navigation: LUINavigationViewController { get }
    
    public func push(to vc: UIViewController)
    public func pop()
    public func popToRoot()
    public func present(_ vc: UIViewController)
    public func popOver(_ vc: UIViewController)
    public func dismissableModalViewController() -> LUINavigationViewController
}
