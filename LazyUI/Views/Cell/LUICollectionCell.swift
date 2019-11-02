//
//  LUICollectionCell.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public typealias LUICollectionCell = LUICollectionCellClass & LUICellData
open class LUICollectionCellClass: UICollectionViewCell {
    
    private lazy var _interactionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color(for: .intermediateBackground)
        self.addSubview(view)
        self.fill(view, padding: .none, withSafety: false)
        return view
    } ()
    
    private var interactionBackgroundView: UIView {
        get {
            let view = self._interactionBackgroundView
            self.sendSubviewToBack(view)
            view.alpha = 0.0
            return view
        }
        set {
            self._interactionBackgroundView = newValue
        }
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureCollectionViewCell()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureCollectionViewCell()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configureCollectionViewCell()
    }
    
    private func animateCellBackground() {
        
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), animations: {
            self.interactionBackgroundView.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), animations: {
                self.interactionBackgroundView.alpha = 0.0
            })
        }
        
    }
    
    internal func configureCollectionViewCell() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
        
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
    }
    
    @objc internal func cellTapped() {
        self.animateCellBackground()
        
        if let cell = self as? LUICellData {
            cell.action?()
        }
    }
}

