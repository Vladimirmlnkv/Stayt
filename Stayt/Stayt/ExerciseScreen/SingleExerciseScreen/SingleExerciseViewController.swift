//
//  SingleExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class SingleExerciseViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var remainingLabel: UILabel!
    
    @IBOutlet var durationButton: DisclosureButton!
    
    var viewModel: ExerciseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        durationButton.setTitle(viewModel.currentDuration, for: .normal)
        setRemaining(hidden: true)
    }
    
    fileprivate func setRemaining(hidden: Bool) {
        remainingLabel.isHidden = hidden
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        viewModel.dismiss()
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        viewModel.playButtonAction()
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        viewModel.showInfo()
    }
    
    @IBAction func durationButtonAction(_ sender: Any) {
        viewModel.changeDuration()
    }
    
}

extension SingleExerciseViewController: ExerciseViewModelDelegate {
    
    func update(remaining newRemaining: String) {
        remainingLabel.text = newRemaining
    }
    
    func update(duration newDuration: String) {
        durationButton.setTitle(newDuration, for: .normal)
    }
    
    func disableUIAndHideRemaining() {
        setRemaining(hidden: true)
        playButton.isEnabled = false
    }
    
    func showRemaining(with value: String) {
        remainingLabel.text = value
        setRemaining(hidden: false)
        durationButton.isHidden = true
    }
    
    func updatePlayButton(image newImage: UIImage) {
        playButton.setImage(newImage, for: .normal)
    }
}
