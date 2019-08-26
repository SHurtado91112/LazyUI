//
//  LUIPannable.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/25/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

protocol LUIPannable {
    var panGestureRecognizer: UIPanGestureRecognizer { get }
    var originalPosition: CGPoint { get set }
    var currentPositionTouched: CGPoint { get set }
    
    func panGestureAction(_ panGesture: UIPanGestureRecognizer)
    
    var dismissedAction:(() -> Void)? { get set }
}
