//
//  ExerciseSectionView.swift
//  Stayt
//
//  Created by Владимир Мельников on 19/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ExerciseSectionView: UIView {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sectionTitleLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("ExerciseSectionView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("ExerciseSectionView")
    }
}
