//
//  ExerciseCoordinator.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol ExerciseCoodinatorDelegate {
    func durationsUpdated()
}

class ExerciseCoodinator {
    
    fileprivate let exercise: Exercise
    fileprivate let presentingVC: UIViewController
    fileprivate let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    fileprivate var afterExerciseVC: AfterExerciseViewController!
    fileprivate let historyManager: HistoryManager!
    fileprivate var coordinators = [String: Any]()
    fileprivate var delegate: ExerciseCoodinatorDelegate?
    fileprivate var exerciseVC: UIViewController!
    fileprivate let exercisePack: ExercisePack?
    fileprivate var menuHandler: DurationsOptionsMenuHandler?
    fileprivate var tutorialVC: UIViewController?
    
    init(exercise: Exercise, presentingVC: UIViewController, exercisePack: ExercisePack?=nil) {
        self.exercise = exercise
        self.presentingVC = presentingVC
        self.historyManager = HistoryManager(exercise: exercise)
        self.exercisePack = exercisePack
    }
    
    func start() {
        if let pack = exercisePack {
            if let index = pack.exercises.index(of: exercise), index == pack.currentExerciseNumber, exercise.shouldShowTutorialFirst {
                showTutorialScreen()
            } else {
                showExerciseScreen(on: presentingVC)
            }
        } else {
            showExerciseScreen(on: presentingVC)
        }
    }
    
    fileprivate func showTutorialScreen() {
        let vc = storyboard.instantiateViewController(withIdentifier: "DescriptionPageViewController") as! DescriptionPageViewController
        vc.exerciseTitle = exercise.descriptionName
        vc.exerciseDescription = exercise.descriptionText
        vc.shouldShowStartButton = true
        vc.pageDelegate = self
        tutorialVC = vc
        presentingVC.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func showExerciseScreen(on parentVC: UIViewController) {
        if exercise.activities.count > 1 || exercise.allowsRounds || !exercise.activities.first!.stages.isEmpty {
            let exerciseVC = storyboard.instantiateViewController(withIdentifier: "MultipleExerciseViewController") as! MultipleExerciseViewController
            exerciseVC.viewModel = MultipleExerciseViewModel(exercise: exercise, coordinationDelegate: self, delegate: exerciseVC, exercisePack: exercisePack)
            delegate = exerciseVC.viewModel
            self.exerciseVC = exerciseVC
            parentVC.present(exerciseVC, animated: true, completion: nil)
        } else {
            let exerciseVC = storyboard.instantiateViewController(withIdentifier: "SingleExerciseViewController") as! SingleExerciseViewController
            let exerciseViewModel = SingleExerciseViewModel(exercise: exercise, coordinationDelegate: self, delegate: exerciseVC, exercisePack: exercisePack)
            exerciseVC.viewModel = exerciseViewModel
            self.exerciseVC = exerciseVC
            parentVC.present(exerciseVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func dismiss() {
        self.presentingVC.dismiss(animated: true, completion: {
            self.exerciseVC = nil
        })
    }
    
}

extension ExerciseCoodinator: ExerciseViewModelCoordinationDelegate {
    
    func showInfoScreen() {
        let vc = storyboard.instantiateViewController(withIdentifier: "ExerciseDescriptionViewController") as! ExerciseDescriptionViewController
        vc.exerciseTitle = exercise.descriptionName
        vc.exerciseDescription = exercise.descriptionText
        exerciseVC.present(vc, animated: true, completion: nil)
    }
    
    func dismiss(shouldConfirm: Bool, completion: @escaping () -> Void) {
        if shouldConfirm {
            let alert = UIAlertController(title: "You're in the middle of exersice", message: "Are you sure you want to stop it?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                completion()
                self.dismiss()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            exerciseVC.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss()
        }
    }
    
    func showDurationPicker(with title: String, currentDuration: Int?, allowedDurations: [Int]?, completion: @escaping (Int) -> Void) {
        if let durations = allowedDurations, durations.count <= 4, !durations.isEmpty {
            menuHandler = DurationsOptionsMenuHandler(superView: exerciseVC.view, title: title, durations: allowedDurations)
            menuHandler!.currentDuration = currentDuration
            menuHandler!.completion = completion
            menuHandler!.showMenu()
        } else {
            let durationPicker = storyboard.instantiateViewController(withIdentifier: "DurationPickerViewController") as! DurationPickerViewController
            durationPicker.labelTitle = title
            durationPicker.currentDuration = currentDuration
            durationPicker.completion = completion
            if let d = allowedDurations {
                durationPicker.durations = d
            }
            exerciseVC.present(durationPicker, animated: true, completion: nil)
        }
    }
    
    func showStagesScreen(for activity: Activity) {
        let stagesCoordinator = StagesCoordinator(activity: activity, presentingVC: exerciseVC, delegate: self)
        coordinators[StagesCoordinator.coordinatorKey] = stagesCoordinator
        stagesCoordinator.start()
    }
    
    func exerciseFinished(roundsCount: Int) {
        historyManager.addExperience(roundsCount: roundsCount)
        afterExerciseVC = storyboard.instantiateViewController(withIdentifier: "AfterExerciseViewController") as! AfterExerciseViewController
        afterExerciseVC.exerciseName = exercise.descriptionName
        let navC = UINavigationController(rootViewController: afterExerciseVC)
        afterExerciseVC.delegate = self
        exerciseVC.present(navC, animated: true, completion: nil)
    }
    
    func endExecrise(with roundsCount: Int, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "You've not completed all rounds", message: "Are you sure you want to stop exercise?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            completion()
            self.exerciseFinished(roundsCount: roundsCount)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        exerciseVC.present(alert, animated: true, completion: nil)
    }
}

extension ExerciseCoodinator: AfterExerciseViewControllerDelegate {
    
    func didPickFeeling(_ feeling: Feeling, note: String?) {
        historyManager.addAfterFeeling(feeling: feeling, text: note)
        dismiss()
    }
    
    func addNoteAction() {
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomFeelingViewController") as! CustomFeelingViewController
        vc.delegate = self
        vc.experience = historyManager.currentExperience()!
        vc.tmpNote = afterExerciseVC.note
        vc.tmpFeeling = afterExerciseVC.selectedFeeling
        afterExerciseVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func skip() {
        dismiss()
    }
    
    func complete() {
        
    }
}

extension ExerciseCoodinator: CustomFeelingViewControllerDelegate {
    
    func didEnter(feeling: String) {
        afterExerciseVC.note = feeling
    }

}

extension ExerciseCoodinator: StagesCoordinatorDelegate {
    
    func stagesCoordinatorDidFinish() {
        coordinators[StagesCoordinator.coordinatorKey] = nil
        delegate?.durationsUpdated()
        exerciseVC.dismiss(animated: true, completion: nil)
    }
}

extension ExerciseCoodinator: DescriptionPageViewControllerDelegate {
    
    func didPressStart() {
        self.showExerciseScreen(on: tutorialVC!)
    }
    
}
