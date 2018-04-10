//
//  StagesActivityCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 10/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class StagesActivityCell: UITableViewCell {

    @IBOutlet var activityNameLabe: UILabel!
    @IBOutlet var stageNameLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var currentActivityView: UIView!
    
    func configure(with viewModel: ActivityCellViewModel) {
        durationLabel.text = viewModel.durationTitle
        activityNameLabe.text = viewModel.title
        stageNameLabel.text = viewModel.subtitle
        currentActivityView.layer.cornerRadius = currentActivityView.frame.width / 2
        activityNameLabe.textColor = Colors.mainActiveColor
        stageNameLabel.textColor = Colors.mainActiveColor
        durationLabel.textColor = Colors.mainActiveColor
    }
    
}
