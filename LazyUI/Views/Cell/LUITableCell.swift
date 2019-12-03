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
    static var identifier: String { get set }
    var action: (()->Void)? { get set }
}

public typealias LUITableCell = LUITableCellClass & LUICellData
open class LUITableCellClass: UITableViewCell, LUIViewThemeProtocol {
    
    // theme protocol
    override open var backgroundColor: UIColor? {
        didSet {
            self.backgroundColorType = self.backgroundColor?.type ?? .empty
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            self.tintColorType = self.tintColor.type
        }
    }
    
    private var _backgroundColorType: LUIColorType = .empty
    public var backgroundColorType: LUIColorType {
        get {
            return self._backgroundColorType
        }
        set {
            self._backgroundColorType = newValue
        }
    }
    
    private var _textColorType: LUIColorType = .empty
    public var textColorType: LUIColorType {
        get {
            return self._textColorType
        }
        set {
            self._textColorType = newValue
        }
    }
    
    private var _tintColorType: LUIColorType = .empty
    public var tintColorType: LUIColorType {
        get {
            return self._tintColorType
        }
        set {
            self._tintColorType = newValue
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.registerForThemeObserver()
    }
    
    deinit {
        self.unregisterForThemeObserver()
    }
    
    // end theme protocol
    
    private lazy var _interactionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = self.interactionBackgroundColor
        self.addSubview(view)
        self.fill(view, padding: .none, withSafety: false)
        return view
    } ()
    
    private var interactionBackgroundColor: UIColor = .color(for: .lightBackground)
    private var interactionBackgroundView: UIView {
        get {
            let view = self._interactionBackgroundView
            self.sendSubviewToBack(view)
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
            self.interactionBackgroundView.backgroundColor = .color(for: .intermediateBackground)
        }) { (finished) in
            UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), animations: {
                self.interactionBackgroundView.backgroundColor = .color(for: .lightBackground)
            })
        }
        
    }
    
    public func replaceBackgroundForAnimation(_ view: UIView) {
        self.interactionBackgroundColor = view.backgroundColor ?? .color(for: .lightBackground)
        self.interactionBackgroundView = view
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
        
        if let cell = self as? LUICellData {
            cell.action?()
        }
    }
}

extension LUITableCellClass: LUIThemeProtocol {

    @objc func themeUpdated() { // reset colors based on last color type
        self.backgroundColor = UIColor.color(for: self.backgroundColorType)
        self.animateCellBackground()
        self.tintColor = UIColor.color(for: self.tintColorType)
    }

    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }

    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }
}
