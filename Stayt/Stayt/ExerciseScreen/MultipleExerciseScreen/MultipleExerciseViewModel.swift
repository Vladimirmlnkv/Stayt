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
    func showRestView(with restTime: Int, delegate: RestViewHandlerDelegate)
    func updateRoundsLabel(_ newValue: Int)
    func hideRoundsView()
    func setIncreaseButton(isHidden: Bool)
    func setDecreaseButton(isHidden: Bool)
    func updateRoundsTitleLabel(_ newValue: String)
    func removeRestTimeRow()
    func showRestTimeRow()
    func reloadRestTime()
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
    
    var numberOfSections: Int {
        let showRestTime = (state != .initial && shouldShowRestTime && roundsRestTime != 0) || (state == .initial && shouldShowRestTime)
        if showRestTime  {
            return 2
        } else {
            return 1
        }
    }
    
    fileprivate var remainingDuration: Int?
    fileprivate var shouldShowHolder = true
    fileprivate var shouldShowRestView = true
    
    fileprivate var roundsRestTime = 60
    fileprivate var currentRound = 1 {
        didSet {
            delegate?.updateRoundsTitleLabel("Round \(currentRound)/\(roundsCount)")
        }
    }
    fileprivate var maxRoundsCount = 12
    
    fileprivate var shouldShowRestTime = false {
        didSet {
            if shouldShowRestTime {
                delegate?.showRestTimeRow()
            } else {
                delegate?.removeRestTimeRow()
            }
        }
    }
    var roundsCount: Int = 1 {
        didSet {
            if roundsCount == 1 {
                delegate?.setDecreaseButton(isHidden: true)
                shouldShowRestTime = false
            } else if roundsCount == maxRoundsCount {
                delegate?.setIncreaseButton(isHidden: true)
            }
            if oldValue == 1 {
                delegate?.setDecreaseButton(isHidden: false)
                shouldShowRestTime = true
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
                if strongSelf.currentActivityNumber! < exercise.feelings.count - 1 {
                    if strongSelf.shouldShowHolder {
                        strongSelf.player?.pause()
                        strongSelf.shouldShowHolder = false
                        strongSelf.delegate?.showHolder(with: strongSelf, activity: exercise.feelings[strongSelf.currentActivityNumber! + 1])
                    }
                } else {
                    strongSelf.currentActivityNumber = strongSelf.exercise.feelings.count
                    strongSelf.delegate?.realodRows(at: [strongSelf.currentActivityNumber! - 1])
                    if strongSelf.currentRound < strongSelf.roundsCount {
                        if strongSelf.roundsRestTime == 0 {
                            if strongSelf.shouldShowHolder {
                                strongSelf.player?.pause()
                                strongSelf.shouldShowHolder = false
                                strongSelf.delegate?.showHolder(with: strongSelf, activity: exercise.feelings[0])
                            }
                        } else {
                            if strongSelf.shouldShowRestView {
                                strongSelf.player?.pause()
                                strongSelf.shouldShowRestView = false
                                strongSelf.delegate?.showRestView(with: strongSelf.roundsRestTime, delegate: strongSelf)
                            }
                        }
                    } else {
                        strongSelf.player?.pause()
                        strongSelf.state = .done
                    }
                }
            } else {
                strongSelf.delegate?.realodRows(at: [strongSelf.currentActivityNumber!])
            }
        }

    }
    
    func activityCellViewModel(for indexPath: IndexPath) -> ActivityCellViewModel {
        
        if indexPath.section == 1 {
            let durationTitle = "\(roundsRestTime / 60) min"
            let viewModel = ActivityCellViewModel(isCompleted: false, allowsEditing: state == .initial, title: "Rounds rest time", durationTitle: durationTitle, delegate: self, isCurrentActivity: false)
            
            return viewModel
        } else {
            var isCompleted = false
            let activity = exercise.feelings[indexPath.row]
            var durationTitle = "\(activity.durationString) min"
            var isCurrentActivity = false
            if let currentAcitivityNumber = currentActivityNumber {
                isCompleted = currentAcitivityNumber > indexPath.row
                if indexPath.row == currentAcitivityNumber {
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
    
    override func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if state == .done {
            coordinationDelegate?.exerciseFinished(roundsCount: currentRound)
        }
    }
    
    fileprivate func incrementCurrentRound() {
        currentRound += 1
        if currentRound == roundsCount && numberOfSections == 2 {
            shouldShowRestTime = false
        }
    }
}

extension MultipleExerciseViewModel: HolderViewHandlerDelegate {
    
    func holderDidFinish() {
        shouldShowHolder = true
        if currentActivityNumber == exercise.feelings.count {
            currentActivityNumber = 0
            incrementCurrentRound()
            currentTimeDuration = exercise.feelings[currentActivityNumber!].duration
            delegate?.reloadTableView()
        } else {
            currentActivityNumber! += 1
            currentTimeDuration = exercise.feelings[currentActivityNumber!].duration
            delegate?.realodRows(at: [currentActivityNumber!, currentActivityNumber! - 1])
        }
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
}

extension MultipleExerciseViewModel: RestViewHandlerDelegate {
    
    func didResume() {
        shouldShowRestView = true
        currentActivityNumber = 0
        incrementCurrentRound()
        currentTimeDuration = exercise.feelings[currentActivityNumber!].duration
        delegate?.reloadTableView()
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    func didStop(completion: @escaping () -> Void) {
        coordinationDelegate?.endExecrise(with: currentRound, completion: {
            completion()
        })
    }
}

extension MultipleExerciseViewModel: SingleActivityCellDelegate {
    
    func changeDuration(for viewModel: ActivityCellViewModel) {
        if let index = exercise.feelings.index(where: {$0.descriptionName == viewModel.title}) {
            let activity = exercise.feelings[index]
            coordinationDelegate?.showDurationPicker(with: titleForActivityDuration(from: activity), currentDuration: activity.duration, allowedDurations: nil, completion: { duration in
                activity.duration = duration
                if let index = self.exercise.feelings.index(where: {$0.name == activity.name}) {
                    self.delegate?.realodRows(at: [index])
                }
            })
        } else {
            var allowedDurations = [Int]()
            for i in 0...5 {
                allowedDurations.append(i * 60)
            }
            coordinationDelegate?.showDurationPicker(with: "Select duration for rest between sets", currentDuration: roundsRestTime, allowedDurations: allowedDurations, completion: { (duration) in
                self.roundsRestTime = duration
                self.delegate?.reloadRestTime()
            })
        }
    }

}
