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
    func showHolder(with transitionTime: Int, delegate: HolderViewHandlerDelegate, activity: Activity)
    func showRestView(with restTime: Int, delegate: RestViewHandlerDelegate)
    func updateRoundsLabel(_ newValue: Int)
    func hideRoundsView()
    func setIncreaseButton(isHidden: Bool)
    func setDecreaseButton(isHidden: Bool)
    func updateRoundsTitleLabel(_ newValue: String)
    func removeRestTimeRow()
    func showRestTimeRow()
    func reloadRestTime()
    func startProgressBar(with duration: Int)
    func pauseProgressBar()
    func resumeProgressBar()
    func hideQuestionIcon()
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
                delegate?.hideQuestionIcon()
                if roundsCount > 1 {
                    delegate?.updateRoundsTitleLabel("Round \(currentRound)/\(roundsCount)")
                } else {
                    delegate?.updateRoundsTitleLabel("")
                }
                startProgressBar()
            }
            if state == .play {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "pause"))
                delegate?.resumeProgressBar()
            } else if state == .pause {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
                delegate?.pauseProgressBar()
            } else if state == .done {
                delegate?.updatePlayButton(image: #imageLiteral(resourceName: "play"))
                delegate?.disableUI()
            }
        }
    }
    
    var allowsRounds: Bool {
        return exercise.allowsRounds
    }
    
    var allowsReordering: Bool {
        return exercise.allowsReorderActivities
    }
    
    var activitiesCount: Int {
        return exercise.activities.count
    }
    
    var activities: [Activity] {
        return Array(exercise.activities)
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
    
    fileprivate let transitionTime = 5
    fileprivate var roundsRestTime = 0
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
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: MultipleExerciseViewModelDelegate, exercisePack: ExercisePack?) {
        super.init(exercise: exercise, coordinationDelegate: coordinationDelegate, exercisePack: exercisePack)
        self.delegate = delegate
        roundsRestTime = exercise.defaultRestTime
        updateBlock = { [weak self] time -> Void in
            guard let strongSelf = self else { return }
            
            let passedTime = Int64(time.value) / Int64(time.timescale)
            let remainingTime = strongSelf.currentTimeDuration! - Int(passedTime)

            strongSelf.remainingDuration = remainingTime
            if remainingTime == 0 {
                strongSelf.playSound()
            }
            if remainingTime == -1 {
                if let currentStageNumber = strongSelf.currentStage,
                        strongSelf.currentActivityNumber! <= exercise.activities.count - 1,
                        currentStageNumber < exercise.activities[strongSelf.currentActivityNumber!].stages.count - 1
                {
                    strongSelf.currentStage! += 1
                    strongSelf.currentTimeDuration = exercise.activities[strongSelf.currentActivityNumber!].stages[strongSelf.currentStage!].duration
                    strongSelf.player?.pause()
                    strongSelf.player?.seek(to: kCMTimeZero)
                    strongSelf.player?.play()
                } else {
                    strongSelf.currentStage = nil
                    if strongSelf.currentActivityNumber! < exercise.activities.count - 1 {
                        if strongSelf.shouldShowHolder {
                            strongSelf.player?.pause()
                            strongSelf.shouldShowHolder = false
                            strongSelf.delegate?.showHolder(with: strongSelf.transitionTime, delegate: strongSelf, activity: exercise.activities[strongSelf.currentActivityNumber! + 1])
                        }
                    } else {
                        strongSelf.currentActivityNumber = strongSelf.exercise.activities.count
                        strongSelf.delegate?.realodRows(at: [strongSelf.currentActivityNumber! - 1])
                        if strongSelf.currentRound < strongSelf.roundsCount {
                            if strongSelf.roundsRestTime == 0 {
                                if exercise.activities.count == 1 {
                                    strongSelf.player?.pause()
                                    strongSelf.startNextRound()
                                } else if strongSelf.shouldShowHolder {
                                    strongSelf.player?.pause()
                                    strongSelf.shouldShowHolder = false
                                    strongSelf.delegate?.showHolder(with: strongSelf.transitionTime, delegate: strongSelf, activity: exercise.activities[0])
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
                }
            } else {
                if strongSelf.currentActivityNumber! < strongSelf.exercise.activities.count {
                    strongSelf.delegate?.realodRows(at: [strongSelf.currentActivityNumber!])
                }
            }
        }

    }
    
    func activityCellViewModel(for indexPath: IndexPath) -> ActivityCellViewModel {
        
        if indexPath.section == 1 {
            let durationTitle = passiveStringDuration(from: roundsRestTime)
            let viewModel = ActivityCellViewModel(isCompleted: false, allowsEditing: state == .initial, title: "Rounds rest time", durationTitle: durationTitle, delegate: self, isCurrentActivity: false)
            
            return viewModel
        } else {
            var isCompleted = false
            let activity = exercise.activities[indexPath.row]
            var durationTitle = passiveStringDuration(from: activity.duration)
            var isCurrentActivity = false
            var title = activity.descriptionName!
            if let currentAcitivityNumber = currentActivityNumber {
                isCompleted = currentAcitivityNumber > indexPath.row
                if indexPath.row == currentAcitivityNumber {
                    if let d = remainingDuration {
                        durationTitle = stringDuration(from: d)
                    } else {
                        durationTitle = stringDuration(from: currentTimeDuration!)
                    }
                    isCurrentActivity = true
                    if let stage = currentStage, !exercise.activities[currentAcitivityNumber].stages.isEmpty {
                        let stageName = exercise.activities[currentAcitivityNumber].stages[stage].name!
                        title = stageName + " \(stage+1)/\(exercise.activities[currentAcitivityNumber].stages.count)"
                    }
                }
            }
            let viewModel = ActivityCellViewModel(isCompleted: isCompleted, allowsEditing: (state == .initial && activity.allowsEditDuration), title: title, durationTitle: durationTitle, delegate: self, isCurrentActivity: isCurrentActivity)
            
            return viewModel
        }
    }
    
    func moveActivity(from index: Int, to destinationIndex: Int) {
        try! mainRealm.write {
            self.exercise.activities.move(from: index, to: destinationIndex)
        }
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
            incrementCurrentExerciseInPack()
            coordinationDelegate?.exerciseFinished(roundsCount: currentRound)
        }
    }
    
    fileprivate func startProgressBar() {
        let sessionDuration = exercise.activities.reduce(0) { $0 + $1.duration + ($1.stages.count > 0 ? $1.stages.count : 1) } + (exercise.activities.count - 1) * transitionTime + exercise.activities.count - 1
        delegate?.startProgressBar(with: sessionDuration)
    }
    
    fileprivate func incrementCurrentRound() {
        currentRound += 1
        if currentRound == roundsCount && numberOfSections == 2 {
            shouldShowRestTime = false
        }
    }
    
    fileprivate func startNextRound() {
        currentActivityNumber = 0
        incrementCurrentRound()
        currentTimeDuration = exercise.activities[currentActivityNumber!].duration
        checkStages()
        delegate?.reloadTableView()
        player?.seek(to: kCMTimeZero)
        player?.play()
        startProgressBar()
    }
}

extension MultipleExerciseViewModel: HolderViewHandlerDelegate {
    
    func holderDidFinish() {
        shouldShowHolder = true
        if currentActivityNumber == exercise.activities.count {
            startNextRound()
        } else {
            currentActivityNumber! += 1
            currentTimeDuration = exercise.activities[currentActivityNumber!].duration
            checkStages()
            delegate?.realodRows(at: [currentActivityNumber!, currentActivityNumber! - 1])
            player?.seek(to: kCMTimeZero)
            player?.play()
        }
    }
    
    fileprivate func checkStages() {
        if !exercise.activities[currentActivityNumber!].stages.isEmpty {
            currentStage = 0
            currentTimeDuration = exercise.activities[currentActivityNumber!].stages.first!.duration
        }
    }
    
}

extension MultipleExerciseViewModel: RestViewHandlerDelegate {
    
    func didResume() {
        shouldShowRestView = true
        currentActivityNumber = 0
        incrementCurrentRound()
        currentTimeDuration = exercise.activities[currentActivityNumber!].duration
        checkStages()
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
        if let index = exercise.activities.index(where: {$0.descriptionName == viewModel.title}) {
            let activity = exercise.activities[index]
            if activity.stages.isEmpty {
                coordinationDelegate?.showDurationPicker(with: titleForActivityDuration(from: activity), currentDuration: activity.duration, allowedDurations: Array(activity.avaliableDurations), completion: { duration in
                    try! mainRealm.write {
                        activity.duration = duration
                    }
                    if let index = self.exercise.activities.index(where: {$0.name == activity.name}) {
                        self.delegate?.realodRows(at: [index])
                    }
                })
            } else {
                coordinationDelegate?.showStagesScreen(for: activity)
            }
        } else {
            let allowedDurations = Array(exercise.roundsRestTimes)
            coordinationDelegate?.showDurationPicker(with: "Rest time", currentDuration: roundsRestTime, allowedDurations: allowedDurations, completion: { (duration) in
                self.roundsRestTime = duration
                self.delegate?.reloadRestTime()
            })
        }
    }

}

extension MultipleExerciseViewModel: ExerciseCoodinatorDelegate {
    
    func durationsUpdated() {
        delegate?.reloadTableView()
    }
}
