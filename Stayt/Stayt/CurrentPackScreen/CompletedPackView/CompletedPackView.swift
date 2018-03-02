//
//  CompletedPackView.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol CompletedPackViewDelegate {
    func startOver()
}

class CompletedPackView: UIView {
    
    @IBOutlet var startButton: UIButton!
    
    var delegate: CompletedPackViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("CompletedPackView")
        setupStartButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("CompletedPackView")
        setupStartButton()
    }

    @IBAction func startButtonAction(_ sender: Any) {
        delegate.startOver()
    }
    
    fileprivate func setupStartButton() {
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        startButton.layer.cornerRadius = 10.0
    }
}
