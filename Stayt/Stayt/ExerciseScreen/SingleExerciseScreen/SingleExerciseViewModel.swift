//
//  ExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import AVKit

protocol SingleExerciseViewModelDelegate: class {
    func update(duration newDuration: String)
    func update(remaining newRemaining: String)
    func showRemaining(with value: String)
    func disableUIAndHideRemaining()
    func updatePlayButton(image newImage: UIImage)
}

class SingleExerciseViewModel: ExerciseViewModel, TimerDisplay {
    
    override var state: ExerciseViewModelState {
        didSet {
            if oldValue == .initial {
                delegate?.showRemaining(with: stringDuration(from: remainingDuration!))
            }
            if state == .play {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "pause"))
            } else if state == .pause {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
            } else if state == .done {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
                delegate?.disableUIAndHideRemaining()
            }
        }
    }
    
    fileprivate weak var delegate: SingleExerciseViewModelDelegate?

    var currentDuration: String {
        return "\(exercise.feelings.first!.durationString) min"
    }
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: SingleExerciseViewModelDelegate) {
        super.init(exercise: exercise, coordinationDelegate: coordinationDelegate)
        self.delegate = delegate
    }
    
    @objc override func updateTimer() {
        if let _ = remainingDuration {
            remainingDuration! -= 1
            
            if remainingDuration == 0 {
                playSound()
            }
            if remainingDuration == -1 {
                timer.invalidate()
                state = .done
            } else {
                delegate?.update(remaining: stringDuration(from: remainingDuration!))
            }
        }
    }
    
    func changeDuration() {
        coordinationDelegate?.showDurationPicker(for: exercise.feelings.first!)
    }
}

extension SingleExerciseViewModel: DurationPickerViewControllerDelegate {
    func didSelect(duration: Int, for feeling: Feeling) {
        try! mainRealm.write {
            feeling.duration = duration
        }
        delegate?.update(duration: currentDuration)
    }
}
