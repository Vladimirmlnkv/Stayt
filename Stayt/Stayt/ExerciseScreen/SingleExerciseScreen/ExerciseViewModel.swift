//
//  ExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import AVKit

protocol ExerciseViewModelCoordinationDelegate: class {
    func showInfoScreen()
    func dismiss(shouldConfirm: Bool, completion: @escaping () -> Void)
    func showDurationPicker()
    func exerciseFinished()
}

protocol ExerciseViewModelDelegate: class {
    func update(duration newDuration: String)
    func update(remaining newRemaining: String)
    func showRemaining(with value: String)
    func disableUIAndHideRemaining()
    func updatePlayButton(image newImage: UIImage)
}

class ExerciseViewModel: NSObject, TimerDisplay {
    
    enum ExerciseViewModelState {
        case play, pause, initial, done
    }
    
    fileprivate var state = ExerciseViewModelState.initial {
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
    
    fileprivate var timer = Timer()
    fileprivate var remainingDuration: Int?
    fileprivate var player: AVAudioPlayer!
    fileprivate let exercise: Exercise
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
            if remainingDuration == nil { remainingDuration = exercise.feelings.first!.duration }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            state = .play
        } else if state == .play {
            state = .pause
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        if let _ = remainingDuration {
            remainingDuration! -= 1
            
            if remainingDuration == 0 {
                let soundPath = Bundle.main.path(forResource: "meditationBell", ofType: "mp3")
                player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
                player.delegate = self
                player.play()
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
        coordinationDelegate?.showDurationPicker()
    }
    
    func showInfo() {
        coordinationDelegate?.showInfoScreen()
    }
    
    func dismiss() {
        coordinationDelegate?.dismiss(shouldConfirm: state == .play) {
            self.timer.invalidate()
        }
    }
}

extension ExerciseViewModel: DurationPickerViewControllerDelegate {
    func didSelect(duration: Int, for feeling: Feeling) {
        feeling.duration = duration
        delegate?.update(duration: currentDuration)
    }
}

extension ExerciseViewModel: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if state == .done {
            coordinationDelegate?.exerciseFinished()
        }
    }
    
}
