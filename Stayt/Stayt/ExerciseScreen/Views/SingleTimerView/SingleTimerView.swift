//
//  SingleTimerView.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class SingleTimerView: UIView {

    @IBOutlet var durationButton: DisclosureButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("SingleTimerView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("SingleTimerView")
    }

    func hideRemaining(_ hide: Bool) {
        spinner.isHidden = hide
        label.isHidden = hide
    }
}
