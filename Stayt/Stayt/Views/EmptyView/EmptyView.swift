//
//  EmptyView.swift
//  Stayt
//
//  Created by Владимир Мельников on 07/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet var messageLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("EmptyView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("EmptyView")
    }

}
