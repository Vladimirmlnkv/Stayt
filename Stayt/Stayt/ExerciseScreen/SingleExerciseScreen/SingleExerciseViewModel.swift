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
                delegate?.showRemaining(with: stringDuration(from: currentTimeDuration!))
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
        return passiveStringDuration(from: exercise.activities.first!.duration)
    }
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: SingleExerciseViewModelDelegate, exercisePack: ExercisePack?) {
        super.init(exercise: exercise, coordinationDelegate: coordinationDelegate, exercisePack: exercisePack)
        self.delegate = delegate
        
        updateBlock = { [weak self] time -> Void in
            guard let strongSelf = self else { return }
            if let _ = strongSelf.currentTimeDuration {
                let passedTime = Int64(time.value) / Int64(time.timescale)
                let remainingTime = strongSelf.currentTimeDuration! - Int(passedTime)

                if remainingTime == 0 {
                    strongSelf.playSound()
                }
                if remainingTime == -1 {
                    strongSelf.player?.pause()
                    strongSelf.state = .done
                } else {
                    strongSelf.delegate?.update(remaining: strongSelf.stringDuration(from: remainingTime))
                }
            }
        }
    }
    
    func changeDuration() {
        let activity = exercise.activities.first!
        coordinationDelegate?.showDurationPicker(with: titleForActivityDuration(from: activity), currentDuration: activity.duration, allowedDurations: Array(activity.avaliableDurations), completion: { duration in
            try! mainRealm.write {
                activity.duration = duration
            }
            self.delegate?.update(duration: self.currentDuration)
        })
    }
}
