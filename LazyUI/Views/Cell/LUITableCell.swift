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

open class LUITableCell: UITableViewCell {
    
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
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func configureTableViewCell() {
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
    }
    
}
