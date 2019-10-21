//
//  LUITableCell.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/15/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUICellData {
    func setUpCell()
    func formatCell(for data: Any)
}

public protocol LUIActionCellData: LUICellData {
    var action: (()->Void)? { get set }
}

open class LUIActionTableCell: LUITableCell {
    
    @objc override internal func cellTapped() {
        super.cellTapped()
        
        if let cell = self as? LUIActionCellData {
            cell.action?()
        }
    }
    
}

open class LUITableCell: UITableViewCell {
    
    private lazy var _interactionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color(for: .intermidiateBackground)
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
        self.init(style: .default, reuseIdentifier: nil)
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureTableViewCell()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureTableViewCell()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configureTableViewCell()
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
    
    internal func configureTableViewCell() {
        self.selectionStyle = .none
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
        
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
    }
    
    @objc internal func cellTapped() {
        self.animateCellBackground()
    }
}
