//
//  CustomFeelingCell.swift
//  Stayt
//
//  Created by Владимир Мельников on 18/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class CustomFeelingCell: UITableViewCell {

    @IBOutlet var plusImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plusImage.tintColor = UIColor.white
        plusImage.image = #imageLiteral(resourceName: "plain_plus")
    }

}
