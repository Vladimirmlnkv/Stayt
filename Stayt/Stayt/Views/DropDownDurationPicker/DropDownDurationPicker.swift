//
//  DropDownDurationPicker.swift
//  Stayt
//
//  Created by Владимир Мельников on 04/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class DropDownDurationPicker: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("DropDownDurationPicker")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("DropDownDurationPicker")
    }

}
