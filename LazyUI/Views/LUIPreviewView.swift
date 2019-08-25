//
//  LUIPreviewView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public enum LUIAspectRatio {
    case standard
    case wide
    case square
}

extension LUIAspectRatio {
    var inversed: LUIAspectRatio {
        switch self {
            case .standard:
                return .wide
            case .wide:
                return .standard
            case .square:
                return .square
        }
    }
    
    var value: Double {
        switch self {
            case .standard:
                return 4.0/3.0
            case .wide:
                return 16.0/9.0
            case .square:
                return 1.0
        }
    }
}

public protocol LUIPreviewContent {
    var aspectRatio: LUIAspectRatio { get }
}

open class LUIPreviewView: LUIView {

    var content: LUIPreviewContent? = nil {
        didSet {
            if let image = self.content as? UIImage {
                self.imageView.image = image
                self.imageView.width(to: self.widthAnchor, constraintOperator: .equal)
                
                self.imageView.aspectRatio(image.aspectRatio)
                self.height(to: self.imageView.heightAnchor, constraintOperator: .equal)
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        self.backgroundColor = .clear
        self.addSubview(iv)
        self.fill(iv, padding: .none, withSafety: false)
        return iv
    } ()
    
}
