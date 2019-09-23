//
//  UIAlertController+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 9/23/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    override open func viewDidLayoutSubviews() {
        self.view.tintColor = UIColor.color(for: .theme)
        self.view.backgroundColor = UIColor.color(for: .lightBackground)
        self.view.layer.cornerRadius = 15.0 // constant for alert view
        self.view.clipsToBounds = true
    }
    
    static public func presentAlert(title: String, message: String, actionText: String = "Okay", viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static public func presentAlertWithOptions(title: String, message: String, options: [UIAlertAction], viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for option in options {
            alert.addAction(option)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
