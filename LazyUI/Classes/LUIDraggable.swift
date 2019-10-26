//
//  LUIDraggable.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

open class LUIDraggable: NSObject {
    
    private var viewSet = [UIView: CGPoint]()
    private lazy var gestureRecognizer: UIGestureRecognizer = {
        let recog = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        recog.minimumNumberOfTouches = 1
        recog.minimumNumberOfTouches = 1
        return recog
    } ()
    private static let draggableManager = LUIDraggable()
    
    private override init() {
        super.init()
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        
        guard let touchedView = sender.view else {
            return
        }
        
        if let lastLocation = self.viewSet[touchedView] {
            let translation  = sender.translation(in: touchedView.superview)
            touchedView.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        }
        self.viewSet[touchedView] = touchedView.center
    }
    
    public static func addView(_ view: UIView) {
        let recognizer = self.draggableManager.gestureRecognizer
        view.addGestureRecognizer(recognizer)
    }
}
