//
//  LUIView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIView: UIView {

    private var _scrollView: UIScrollView = UIScrollView()
    
    private var isRootView: Bool {
        return self.contentScrollView.isDescendant(of: self)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(root: Bool) {
        self.init(frame: .zero)
        
        if root {
            self.setUpScrollView()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isRootView {
            self.contentScrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
        }
    }
    
    override open func addSubview(_ view: UIView) {
        if self.isRootView {
            self.contentScrollView.addSubview(view)
        } else {
            super.addSubview(view)
        }
    }
    
    // scroll view control and set up
    open var contentScrollView: UIScrollView {
        return self._scrollView
    }
    
    // private
    private func setUpScrollView() {
        self.addSubview(self._scrollView)
        self.fill(self._scrollView, padding: .none)
    }
}
