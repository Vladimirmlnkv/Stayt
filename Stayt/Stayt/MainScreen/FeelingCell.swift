//
//  FeelingCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class FeelingCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
