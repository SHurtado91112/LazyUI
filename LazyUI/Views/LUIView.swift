//
//  LUIView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUIViewProtocol {
    func setUpView()
}

public typealias LUIView = LUIViewClass & LUIViewProtocol

open class LUIViewClass: UIView {

    public convenience init() {
        self.init(frame: .zero)
        
        self.initView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override open func addSubview(_ view: UIView) {
        super.addSubview(view)
    }
    
    private func initView() {
        // by default
        self.backgroundColor = UIColor.color(for: .lightBackground)
        
        if let view = self as? LUIView {
            view.setUpView()
        }
    }
}
