//
//  SingleActivityCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol SingleActivityCellDelegate {
    func changeDuration(for acitivity: Feeling)
}

class SingleActivityCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var durationButton: UIButton!

    fileprivate var delegate: SingleActivityCellDelegate!
    fileprivate var activity: Feeling!
    
    @IBAction func durationButtonAction(sender: Any) {
        delegate.changeDuration(for: activity)
    }

    func configure(with activity: Feeling, delegate: SingleActivityCellDelegate, isCompleted: Bool, allowsEditing: Bool) {
        self.activity = activity
        self.delegate = delegate
        titleLabel.text = activity.descriptionName
        durationButton.setTitle(activity.durationString, for: .normal)
        accessoryType = isCompleted ? .checkmark : .none
        if allowsEditing {
            durationButton.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
            durationButton.isUserInteractionEnabled = true
        } else {
            durationButton.setImage(nil, for: .normal)
            durationButton.isUserInteractionEnabled = false
        }
    }
}
