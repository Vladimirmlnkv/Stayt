//
//  FinalOnboardingViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 29/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol FinalOnboardingViewControllerDelegate: class {
    func didPressStart()
}

class FinalOnboardingViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    weak var delegate: FinalOnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        startButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        delegate?.didPressStart()
    }
    
}
