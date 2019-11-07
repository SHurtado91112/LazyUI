//
//  LUICarouselCell.swift
//  LazyUI
//
//  Created by Steven Hurtado on 11/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

protocol LUICarouselCellDelegate {
    func previewRequested(for image: UIImage)
}

open class LUICarouselCell: LUICollectionCell {
    
    public static var identifier: String = "LUICarouselCell"
    public var action: (() -> Void)?
    
    var delegate: LUICarouselCellDelegate?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    public func setUpCell() {
        self.addSubview(self.imageView)
        self.fill(self.imageView, padding: .none, withSafety: false)
    }
    
    public func formatCell(for data: Any) {
        if let img = data as? UIImage {
            self.imageView.image = img
            self.action = {
                self.delegate?.previewRequested(for: img)
            }
        }
    }

}
