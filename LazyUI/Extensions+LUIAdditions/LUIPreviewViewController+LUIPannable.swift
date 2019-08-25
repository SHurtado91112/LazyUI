//
//  LUIPreviewViewController+LUIPannable.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/25/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

fileprivate let VELOCITY_THRESHOLD: CGFloat = 1500

extension LUIPreviewViewController: LUIPannable {
    
    var panGestureRecognizer: UIPanGestureRecognizer {
        return UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:)))
    }
    
    var originalPosition: CGPoint {
        get {
            return self._originalPosition
        }
        set {
            self._originalPosition = newValue
        }
    }
    
    var currentPositionTouched: CGPoint {
        get {
            return self._currentPositionTouched
        }
        set {
            self._currentPositionTouched = newValue
        }
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.view)
        
        if panGesture.state == .began {
            self.originalPosition = self.view.center
            self.currentPositionTouched = panGesture.location(in: self.view)
        } else if panGesture.state == .changed {
            self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: translation.y)
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: self.view)
            
            if velocity.y >= VELOCITY_THRESHOLD {
                
                UIView.animate(withDuration: LUIAnimationSpeed.timeInterval(for: .fast), animations: {
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.size.height)
                }, completion: { (finished) in
                    
                    if finished {
                        self.dismiss(animated: false, completion: {
                            self.view.center = self.originalPosition
                        })
                    }
                    
                })
                
            } else {
                
                UIView.animate(withDuration: LUIAnimationSpeed.timeInterval(for: .fast), animations: {
                    self.view.center = self.originalPosition
                })
                
            }
        }
    }
}
