//
//  TextOnboardingViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 29/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class TextOnboardingViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = text
    }
    

}
