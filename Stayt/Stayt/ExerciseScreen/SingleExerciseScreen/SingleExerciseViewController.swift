//
//  SingleExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol ExerciseViewModelCoordinationDelegate: class {
    func showInfoScreen()
    func dismiss(shouldConfirm: Bool)
    func showDurationPicker()
}

protocol ExerciseViewModelDelegate: class {
    func update(duration newDuration: String)
    func showRemaining()
    func updatePlayButton(image newImage: UIImage)
}

class ExerciseViewModel {
    
    enum ExerciseViewModelState {
        case play, pause, initial, done
    }
    
    fileprivate var state = ExerciseViewModelState.initial {
        didSet {
            if oldValue == .initial {
                delegate?.showRemaining()
            }
            if state == .play {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "pause"))
            } else if state == .pause {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
            }
        }
    }
    fileprivate let exercise: Exercise
    //CHECK FOR RETAIN CYCLE
    fileprivate var coordinationDelegate: ExerciseViewModelCoordinationDelegate?
    fileprivate weak var delegate: ExerciseViewModelDelegate?
    
    var title: String {
        return exercise.descriptionName
    }
    
    var currentDuration: String {
        return "\(exercise.feelings.first!.durationString) min"
    }
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: ExerciseViewModelDelegate) {
        self.exercise = exercise
        self.coordinationDelegate = coordinationDelegate
        self.delegate = delegate
    }
    
    func playButtonAction() {
        if state == .initial || state == .pause {
            state = .play
        } else if state == .play {
            state = .pause
        }
    }
    
    func changeDuration() {
        coordinationDelegate?.showDurationPicker()
    }
    
    func showInfo() {
        coordinationDelegate?.showInfoScreen()
    }
    
    func dismiss() {
        coordinationDelegate?.dismiss(shouldConfirm: state == .play)
    }
}

extension ExerciseViewModel: DurationPickerViewControllerDelegate {
    func didSelect(duration: Int, for feeling: Feeling) {
        feeling.duration = duration
        delegate?.update(duration: currentDuration)
    }
}

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
    
    func update(duration newDuration: String) {
        durationButton.setTitle(newDuration, for: .normal)
    }
    
    func showRemaining() {
        setRemaining(hidden: false)
        durationButton.isHidden = true
    }
    
    func updatePlayButton(image newImage: UIImage) {
        playButton.setImage(newImage, for: .normal)
    }
}
