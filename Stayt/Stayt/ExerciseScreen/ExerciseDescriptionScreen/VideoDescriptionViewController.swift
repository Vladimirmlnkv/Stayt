//
//  VideoDescriptionViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol VideoDescriptionViewControllerDelegate: class {
    func didPressStartButton()
    func didPressVideoButton()
}

class VideoDescriptionViewController: UIViewController {
    
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var startButton: UIButton!

    weak var delegate: VideoDescriptionViewControllerDelegate?
    var shouldShowStartButton = false

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        startButton.layer.cornerRadius = 15.0
        
        if !shouldShowStartButton {
            startButton.isHidden = true
        }
        
        videoButton.layer.cornerRadius = videoButton.frame.width / 2
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        delegate?.didPressStartButton()
    }
    
    @IBAction func videoButtonAction(_ sender: Any) {
        delegate?.didPressVideoButton()
    }

    @IBAction func crossButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
