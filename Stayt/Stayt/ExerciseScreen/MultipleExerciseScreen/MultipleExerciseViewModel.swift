//
//  MultipleExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol MultipleExerciseViewModelDelegate: class {
    func setEditing(_ isEditing: Bool)
    func updatePlayButton(image newImage: UIImage)
    func disableUI()
    func reloadTableView()
    func realodRows(at indexes: [Int])
    func showHolder(with delegate: HolderViewHandlerDelegate, activity: Feeling)
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
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, delegate: MultipleExerciseViewModelDelegate) {
        super.init(exercise: exercise, coordinationDelegate: coordinationDelegate)
        self.delegate = delegate
    }
    
    func activityCellViewModel(for index: Int) -> ActivityCellViewModel {
        var isCompleted = false
        let activity = exercise.feelings[index]
        var durationTitle = "\(activity.durationString) min"
        var isCurrentActivity = false
        if let currentAcitivityNumber = currentActivityNumber {
            isCompleted = currentAcitivityNumber > index
            if index == currentAcitivityNumber {
                durationTitle = stringDuration(from: remainingDuration!)
                isCurrentActivity = true
            }
        }
        let viewModel = ActivityCellViewModel(isCompleted: isCompleted, allowsEditing: state == .initial, title: activity.descriptionName, durationTitle: durationTitle, delegate: self, isCurrentActivity: isCurrentActivity)
        
        return viewModel
    }
    
    func moveActivity(from index: Int, to destinationIndex: Int) {
        try! mainRealm.write {
            self.exercise.feelings.move(from: index, to: destinationIndex)
        }
    }
    
    func isAcitivityCompleted(at index: Int) -> Bool {
        return false
    }
    
    @objc override func updateTimer() {
        if currentActivityNumber == nil {
            currentActivityNumber = 0
            remainingDuration = exercise.feelings[currentActivityNumber!].duration
        }
        
        remainingDuration! -= 1
        
        if remainingDuration == 0 {
            playSound()
        }
        
        if remainingDuration == -1 {
            if currentActivityNumber! < exercise.feelings.count - 1 {
                delegate?.showHolder(with: self, activity: exercise.feelings[currentActivityNumber! + 1])
                timer.invalidate()
            } else {
                timer.invalidate()
                state = .done
            }
        } else {
            delegate?.realodRows(at: [currentActivityNumber!])
        }
    }
    
}

extension MultipleExerciseViewModel: HolderViewHandlerDelegate {
    
    func holderDidFinish() {
        currentActivityNumber! += 1
        remainingDuration = exercise.feelings[currentActivityNumber!].duration
        delegate?.realodRows(at: [currentActivityNumber!, currentActivityNumber! - 1])
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
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
        try! mainRealm.write {
            feeling.duration = duration
        }
        if let index = exercise.feelings.index(where: {$0.name == feeling.name}) {
            delegate?.realodRows(at: [index])
        }
    }
    
}
