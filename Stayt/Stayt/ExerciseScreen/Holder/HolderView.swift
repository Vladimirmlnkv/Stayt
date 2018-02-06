//
//  HolderView.swift
//  Stayt
//
//  Created by Владимир Мельников on 06/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class HolderView: UIView, TimerDisplay {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.layer.cornerRadius = 8.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("HolderView")
        setBackgroundColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("HolderView")
        setBackgroundColor()
    }
    
    func updateTime(_ newValue: Int) {
        timeLabel.text = stringDuration(from: newValue)
    }
    
    fileprivate func setBackgroundColor() {
        backgroundColor = .clear
    }
    
}
