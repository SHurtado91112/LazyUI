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
    
}

open class LUIPreviewView: LUIView {

    var content: LUIPreviewContent? = nil {
        didSet {
            if let image = self.content as? UIImage {
                self.frame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
                self.imageView.image = image
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        self.addSubview(iv)
        self.fill(iv, padding: .none)
        return iv
    } ()
    
}
