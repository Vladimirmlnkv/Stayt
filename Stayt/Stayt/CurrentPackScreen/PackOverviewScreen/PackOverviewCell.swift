//
//  PackOverviewCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 23/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol PackOverviewCellDelegate {
    func didPressStartButton(for cell: PackOverviewCell)
}

class PackOverviewCell: UICollectionViewCell {
    
    @IBOutlet var exerciseLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var levelLabel: UILabel!
    
    
    var delegate: PackOverviewCellDelegate!
    
    @IBAction func startButtonAction(_ sender: Any) {
        delegate.didPressStartButton(for: self)
    }

}
