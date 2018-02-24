//
//  RestView.swift
//  Stayt
//
//  Created by Владимир Мельников on 24/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class RestView: UIView, TimerDisplay {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var resumeButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var restView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("RestView")
        backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("RestView")
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        restView.layer.cornerRadius = 8
        resumeButton.layer.cornerRadius = 8
        stopButton.layer.cornerRadius = 8
    }
    
    func updateTime(_ newValue: Int) {
        timeLabel.text = stringDuration(from: newValue)
    }
    
}
