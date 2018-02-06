//
//  FeelingCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol FeelingTimerCellDelegate {
    func selectDuration(for cell: UITableViewCell)
}

class FeelingTimerCell: UITableViewCell {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var label: UILabel!
    @IBOutlet var durationButton: DisclosureButton!
    
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    var delegate: FeelingTimerCellDelegate!
    
    @IBAction func durationButtonAction(_ sender: Any) {
        delegate.selectDuration(for: self)
    }
    
    func updateConstaint(isInitialState: Bool) {
        if isInitialState {
            trailingConstraint.constant = 60
        } else {
            trailingConstraint.constant = 50
        }
    }
    
}
