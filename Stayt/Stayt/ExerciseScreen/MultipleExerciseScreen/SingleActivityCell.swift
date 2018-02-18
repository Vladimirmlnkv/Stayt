//
//  SingleActivityCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol SingleActivityCellDelegate {
    func changeDuration(for viewModel: ActivityCellViewModel)
}

class SingleActivityCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var durationButton: UIButton!
    @IBOutlet var currentActivityView: UIView!
    
    fileprivate var delegate: SingleActivityCellDelegate!
    fileprivate var viewModel: ActivityCellViewModel!
    
    @IBAction func durationButtonAction(sender: Any) {
        delegate.changeDuration(for: viewModel)
    }

    func configure(with viewModel: ActivityCellViewModel) {
        self.viewModel = viewModel
        self.delegate = viewModel.delegate
        titleLabel.text = viewModel.title
        durationButton.setTitle(viewModel.durationTitle, for: .normal)
        accessoryType = viewModel.isCompleted ? .checkmark : .none
        if viewModel.allowsEditing {
            durationButton.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
            durationButton.isUserInteractionEnabled = true
        } else {
            durationButton.setImage(nil, for: .normal)
            durationButton.isUserInteractionEnabled = false
        }
        currentActivityView.layer.cornerRadius = currentActivityView.frame.width / 2
        if viewModel.isCurrentActivity && currentActivityView.isHidden {
            currentActivityView.isHidden = false
        } else if !viewModel.isCurrentActivity {
            currentActivityView.isHidden = true
        }
    }
}
