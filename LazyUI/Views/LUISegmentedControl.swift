//
//  LUISegmentedControl.swift
//  LazyUI
//
//  Created by Steven Hurtado on 11/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUISegmentedControlDelegate {
    func segmentChanged(_ segment: Int)
}

open class LUISegmentedControl: UISegmentedControl, LUIViewProtocol {

    open var delegate: LUISegmentedControlDelegate?
    
    required public init(items: [String]) {
        super.init(items: items)
        self.setUpView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    public func setUpView() {
        
        let themeColor = UIColor.color(for: .theme)
        if #available(iOS 13, *) {
            self.selectedSegmentTintColor = themeColor
        } else {
            self.tintColor = themeColor
        }
        
        // get base system font to replace with substitute font
        let font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        self.setTitleTextAttributes([
            .font: font.substituteFont.withSize(.regular).withStyle(.bold),
            .foregroundColor: UIColor.color(for: .darkText)
        ], for: .normal)
        
        self.setTitleTextAttributes([
            .font: font.substituteFont.withSize(.regular).withStyle(.bold),
            .foregroundColor: UIColor.color(for: .lightText)
        ], for: .selected)
        self.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        self.delegate?.segmentChanged(self.selectedSegmentIndex)
    }
}
