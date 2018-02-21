//
//  MultipleExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import AVKit

protocol MultipleExerciseViewModelDelegate: class {
    func setEditing(_ isEditing: Bool)
    func updatePlayButton(image newImage: UIImage)
    func disableUI()
    func reloadTableView()
    func realodRows(at indexes: [Int])
    func showHolder(with delegate: HolderViewHandlerDelegate, activity: Feeling)
    func updateRoundsLabel(_ newValue: Int)
    func hideRoundsView()
    func setIncreaseButton(isHidden: Bool)
    func setDecreaseButton(isHidden: Bool)
    func updateRoundsTitleLabel(_ newValue: String)
}

struct ActivityCellViewModel {
    let isCompleted: Bool
    let allowsEditing: Bool
    let title: String
    let durationTitle: String
    let delegate: SingleActivityCellDelegate
    let isCurrentActivity: Bool
}

class MultipleExerciseViewModel: ExerciseViewModel, TimerDisplay {
    
    fileprivate weak var delegate: MultipleExerciseViewModelDelegate?
    
    override var state: ExerciseViewModelState {
        didSet {
            if oldValue == .initial {
                delegate?.setEditing(false)
                delegate?.reloadTableView()
                delegate?.hideRoundsView()
                if roundsCount > 1 {
                    delegate?.updateRoundsTitleLabel("Round \(currentRound)/\(roundsCount)")
                } else {
                    delegate?.updateRoundsTitleLabel("")
                }
            }
            if state == .play {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "pause"))
            } else if state == .pause {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
            } else if state == .done {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
                delegate?.disableUI()
            }
        }
    }
    
    var activitiesCount: Int {
        return exercise.feelings.count
    }
    
    var activities: [Feeling] {
        return Array(exercise.feelings)
    }
    
    var allowsReordering: Bool {
        return state == .initial
    }
    
    var allowsEditingDuration: Bool {
        return state == .initial
    }
    
    fileprivate var remainingDuration: Int?
    
    fileprivate var currentRound = 1
    fileprivate var maxRoundsCount = 10
    var roundsCount: Int = 1 {
        didSet {
            if roundsCount == 1 {
                delegate?.setDecreaseButton(isHidden: true)
            } else if roundsCount == maxRoundsCount {
                delegate?.setIncreaseButton(isHidden: true)
            }
            if oldValue == 1 {
                delegate?.setDecreaseButton(isHidden: false)
            } else if oldValue == maxRoundsCount {
                delegate?.setIncreaseButton(isHidden: false)
            }
            delegate?.updateRoundsLabel(roundsCount)
        }
    }
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: MultipleExerciseViewModelDelegate) {
        super.init(exercise: exercise, coordinationDelegate: coordinationDelegate)
        self.delegate = delegate
        
        updateBlock = { [weak self] time -> Void in
            guard let strongSelf = self else { return }
            if strongSelf.currentActivityNumber == nil {
                strongSelf.currentActivityNumber = 0
                strongSelf.currentTimeDuration = exercise.feelings[strongSelf.currentActivityNumber!].duration
            }
            
            let passedTime = Int64(time.value) / Int64(time.timescale)
            let remainingTime = strongSelf.currentTimeDuration! - Int(passedTime)
            strongSelf.remainingDuration = remainingTime
            if remainingTime == 0 {
                strongSelf.playSound()
            }

            if remainingTime == -1 {
                strongSelf.player?.pause()
                if strongSelf.currentActivityNumber! < exercise.feelings.count - 1 {
                    strongSelf.delegate?.showHolder(with: strongSelf, activity: exercise.feelings[strongSelf.currentActivityNumber! + 1])
                } else {
                    strongSelf.state = .done
                }
            } else {
                strongSelf.delegate?.realodRows(at: [strongSelf.currentActivityNumber!])
            }
        }

    }
    
    func activityCellViewModel(for index: Int) -> ActivityCellViewModel {
        var isCompleted = false
        let activity = exercise.feelings[index]
        var durationTitle = "\(activity.durationString) min"
        var isCurrentActivity = false
        if let currentAcitivityNumber = currentActivityNumber {
            isCompleted = currentAcitivityNumber > index
            if index == currentAcitivityNumber {
                if let d = remainingDuration {
                    durationTitle = stringDuration(from: d)
                } else {
                    durationTitle = stringDuration(from: currentTimeDuration!)
                }
                isCurrentActivity = true
            }
        }
        let viewModel = ActivityCellViewModel(isCompleted: isCompleted, allowsEditing: state == .initial, title: activity.descriptionName, durationTitle: durationTitle, delegate: self, isCurrentActivity: isCurrentActivity)
        
        return viewModel
    }
    
    func moveActivity(from index: Int, to destinationIndex: Int) {
            self.exercise.feelings.move(from: index, to: destinationIndex)
    }
    
    func isAcitivityCompleted(at index: Int) -> Bool {
        return false
    }
    
    func increaseRounds() {
        if roundsCount < maxRoundsCount {
            roundsCount += 1
        }
    }
    
    func decreaseRounds() {
        if roundsCount > 1 {
            roundsCount -= 1
        }
    }
}

extension MultipleExerciseViewModel: HolderViewHandlerDelegate {
    
    func holderDidFinish() {
        currentActivityNumber! += 1
        currentTimeDuration = exercise.feelings[currentActivityNumber!].duration
        delegate?.realodRows(at: [currentActivityNumber!, currentActivityNumber! - 1])
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
}

extension MultipleExerciseViewModel: SingleActivityCellDelegate {
    
    func changeDuration(for viewModel: ActivityCellViewModel) {
        if let index = exercise.feelings.index(where: {$0.descriptionName == viewModel.title}) {
            let activity = exercise.feelings[index]
            coordinationDelegate?.showDurationPicker(for: activity)
        }
    }

}

extension MultipleExerciseViewModel: DurationPickerViewControllerDelegate {
    
    func didSelect(duration: Int, for feeling: Feeling) {
        feeling.duration = duration
        if let index = exercise.feelings.index(where: {$0.name == feeling.name}) {
            delegate?.realodRows(at: [index])
        }
    }
    
}
