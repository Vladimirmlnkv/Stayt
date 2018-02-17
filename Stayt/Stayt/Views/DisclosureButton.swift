//
//  DisclosureButton.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

@IBDesignable
class DisclosureButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateTransform()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTransform()
    }
    
    func updateTransform() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func flipImage() {
        imageView!.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
    }
    
    func flipImageToDefault() {
        imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}
