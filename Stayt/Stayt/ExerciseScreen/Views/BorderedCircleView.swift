//
//  BorderedCircleView.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedCircleView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = frame.size.width / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1.0
    }

}
