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
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:)))
        gesture.delegate = self
        return gesture
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
    
    var dismissedAction: (() -> Void)? {
        get {
            return self._dismissedAction
        }
        set {
            self._dismissedAction = newValue
        }
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.view)
//        let navbar = self.navigation?.navigationBar
        
        if panGesture.state == .began {
            self.originalPosition = self.view.center
            self.currentPositionTouched = panGesture.location(in: self.view)
            
            self.navigation?.setNavigationBarHidden(true, animated: true)
        } else if panGesture.state == .changed {
            let maxY = max(translation.y, 0.0)
            
            let alpha = 1.0 - self.view.frame.origin.y / self.view.frame.height
            self.view.alpha = alpha
            
            self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: maxY)
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: self.view)
            
            if velocity.y >= VELOCITY_THRESHOLD {
                
                UIView.animate(withDuration: LUIAnimationSpeed.timeInterval(for: .fast), animations: {
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.size.height)
                    self.view.alpha = 0.0
                }, completion: { (finished) in
                    
                    if finished {
                        self.dismiss(animated: false, completion: {
                            
                            // reset for reuse
                            self.view.center = self.originalPosition
                            self.navigation?.setNavigationBarHidden(false, animated: true)
                            self.view.alpha = 1.0
                            self.dismissedAction?()
                        })
                    }
                    
                })
                
            } else {
                
                UIView.animate(withDuration: LUIAnimationSpeed.timeInterval(for: .fast), animations: {
                    self.view.center = self.originalPosition
                    self.navigation?.setNavigationBarHidden(false, animated: true)
                    self.view.alpha = 1.0
                })
                
            }
        }
    }
}

extension LUIPreviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.scrollView.zoomScale == 1.0
    }
}
