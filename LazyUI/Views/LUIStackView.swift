//
//  LUIStackView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/25/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIStackView: UIScrollView {
    
    // MARK: - Public
    open var distribution: UIStackView.Distribution {
        get {
            return self.stackView.distribution
        }
        set {
            self.stackView.distribution = newValue
        }
    }
    
    open var alignment: UIStackView.Alignment {
        get {
            return self.stackView.alignment
        }
        set {
            self.stackView.alignment = newValue
        }
    }
    
    open var axis: NSLayoutConstraint.Axis {
        get {
            return self.stackView.axis
        }
        set {
            self.stackView.axis = newValue
        }
    }
    
    // MARK: - Private
    private var padding: LUIPaddingType = .none
    
    private lazy var stackView: UIStackView = {
        return self.pageStackView()
    } ()
    private var viewMap : [String : UIView] = [:]
    private var sectionMap : [String : [UIView]] = [:]
    
    public convenience init(padding: LUIPaddingType) {
        self.init()
        self.padding = padding
        self.setUpViews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setUpViews() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.addSubview(self.stackView)
        self.fill(self.stackView, padding: .none)
        
        let padding = LUIPadding.padding(for: self.padding)
        self.stackView.spacing = padding
    
        self.stackView.width(to: self.widthAnchor, constraintOperator: .equal)
    }
    
    open func addArrangedSubtitle(_ text: String, identifier: String = "") {
        let templateLabel = LUILabel(color: .intermidiateText, fontSize: .regular, fontStyle: .regular)
        templateLabel.text = text
        
        self.stackView.addArrangedSubview(templateLabel)
        
        self.stackView.left(templateLabel, fromLeft: true, paddingType: self.padding, withSafety: false)
        self.stackView.right(templateLabel, fromLeft: false, paddingType: self.padding, withSafety: false)
        
        if !identifier.isEmpty {
            self.viewMap[identifier] = templateLabel
        }
    }
    
    open func addArrangedSubview(subtitle: String, contentText: String = "", identifier: String = "") {
        let templateLabel = LUILabel(color: .intermidiateText, fontSize: .small, fontStyle: .regular)
        templateLabel.text = subtitle
        
        let titleLabel = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .regular)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = contentText
        
        self.stackView.addArrangedSubview(templateLabel)
        self.stackView.left(templateLabel, fromLeft: true, paddingType: self.padding, withSafety: false)
        self.stackView.right(templateLabel, fromLeft: false, paddingType: self.padding, withSafety: false)
        
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.left(titleLabel, fromLeft: true, paddingType: self.padding, withSafety: false)
        self.stackView.right(titleLabel, fromLeft: false, paddingType: self.padding, withSafety: false)
        
        if !identifier.isEmpty {
            self.viewMap[identifier] = titleLabel
        }
    }
    
    open func addArrangedSubview(contentView: UIView, identifier: String = "", fill: Bool = false) {
        self.stackView.addArrangedSubview(contentView)

        if fill {
            self.stackView.left(contentView, fromLeft: true, paddingType: self.padding, withSafety: false)
            self.stackView.right(contentView, fromLeft: false, paddingType: self.padding, withSafety: false)
        }
        
        if !identifier.isEmpty {
            self.viewMap[identifier] = contentView
        }
    }
    
    open func addArrangedSubview(contentViews: [UIView], identifier: String = "", fill: Bool = false, direction: NSLayoutConstraint.Axis = .horizontal, distribution: UIStackView.Distribution = .fillEqually, alignment: UIStackView.Alignment = .center) {
        let stackView = UIStackView(arrangedSubviews: contentViews)
        stackView.axis = direction
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = LUIPadding.padding(for: self.padding)
        
        self.stackView.addArrangedSubview(stackView)
        
        if fill {
            self.stackView.left(stackView, fromLeft: true, paddingType: self.padding, withSafety: false)
            self.stackView.right(stackView, fromLeft: false, paddingType: self.padding, withSafety: false)
        }
        
        if !identifier.isEmpty {
            self.sectionMap[identifier] = contentViews
        }
    }
    
    open func addPadding(_ padding: LUIPaddingType) {
        let paddingView = UIView()
        
        paddingView.backgroundColor = .clear
        paddingView.width(to: self.stackView.frame.width)
        paddingView.height(to: LUIPadding.padding(for: padding))
        
        self.addArrangedSubview(contentView: paddingView)
    }
    
    open func addDivider() -> UIView {
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.width, height: 1.0))
        divider.backgroundColor = UIColor.color(for: .border)
        self.addArrangedSubview(contentView: divider, fill: true)
        divider.height(to: 1.0)
        return divider
    }
    
    open func viewFor(id: String) -> UIView? {
        return self.viewMap[id]
    }
    
    open func viewSectionFor(id: String) -> [UIView]? {
        return self.sectionMap[id]
    }
    
    open func fitStack() {
        self.height(to: self.stackView.heightAnchor, constraintOperator: .greaterThan)
    }
    
    private func pageStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
}
