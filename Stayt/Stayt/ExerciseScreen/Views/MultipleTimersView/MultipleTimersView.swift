//
//  MultipleTimersView.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MultipleTimersView: UIView {
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("MultipleTimersView")
        registerCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("MultipleTimersView")
        registerCell()
    }

    fileprivate func registerCell() {
        tableView.register(UINib(nibName: "FeelingTimerCell", bundle: nil), forCellReuseIdentifier: "FeelingTimerCell")
    }
}
