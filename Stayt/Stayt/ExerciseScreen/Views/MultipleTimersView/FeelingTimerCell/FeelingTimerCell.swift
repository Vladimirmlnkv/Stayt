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
    
    var delegate: FeelingTimerCellDelegate!
    
    @IBAction func durationButtonAction(_ sender: Any) {
        delegate.selectDuration(for: self)
    }
    
}
