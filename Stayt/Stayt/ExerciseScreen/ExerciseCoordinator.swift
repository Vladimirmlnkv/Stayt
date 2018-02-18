//
//  ExerciseCoordinator.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ExerciseCoodinator {
    
    fileprivate let exercise: Exercise
    fileprivate let presentingVC: UIViewController
    fileprivate let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    fileprivate var afterExerciseVC: AfterExerciseViewController!
    fileprivate let historyManager: HistoryManager!
    
    fileprivate var exerciseVC: UIViewController!
    
    init(exercise: Exercise, presentingVC: UIViewController) {
        self.exercise = exercise
        self.presentingVC = presentingVC
        self.historyManager = HistoryManager(exercise: exercise)
    }
    
    func start() {
        if exercise.feelings.count > 1 {
            let exerciseVC = storyboard.instantiateViewController(withIdentifier: "MultipleExerciseViewController") as! MultipleExerciseViewController
            exerciseVC.viewModel = MultipleExerciseViewModel(exercise: exercise, coordinationDelegate: self, delegate: exerciseVC)
            self.exerciseVC = exerciseVC
            presentingVC.present(exerciseVC, animated: true, completion: nil)
        } else {
            let exerciseVC = storyboard.instantiateViewController(withIdentifier: "SingleExerciseViewController") as! SingleExerciseViewController
            let exerciseViewModel = SingleExerciseViewModel(exercise: exercise, coordinationDelegate: self, delegate: exerciseVC)
            exerciseVC.viewModel = exerciseViewModel
            self.exerciseVC = exerciseVC
            presentingVC.present(exerciseVC, animated: true, completion: nil)
        }
    }
    
}

extension ExerciseCoodinator: ExerciseViewModelCoordinationDelegate {
    
    func showInfoScreen() {
        let vc = storyboard.instantiateViewController(withIdentifier: "ExerciseDescriptionViewController") as! ExerciseDescriptionViewController
        vc.exerciseTitle = exercise.descriptionName
        vc.exerciseDescription = exercise.description
        exerciseVC.present(vc, animated: true, completion: nil)
    }
    
    func dismiss(shouldConfirm: Bool, completion: @escaping () -> Void) {
        if shouldConfirm {
            let alert = UIAlertController(title: "You're in the middle of exersice", message: "Are you sure you want to stop it?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                completion()
                self.presentingVC.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            exerciseVC.present(alert, animated: true, completion: nil)
        } else {
            presentingVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func showDurationPicker(for activity: Feeling) {
        let durationPicker = storyboard.instantiateViewController(withIdentifier: "DurationPickerViewController") as! DurationPickerViewController
        durationPicker.feeling = activity
        if let exerciseVC = exerciseVC as? SingleExerciseViewController {
            durationPicker.delegate = exerciseVC.viewModel
        } else if let exerciseVC = exerciseVC as? MultipleExerciseViewController {
            durationPicker.delegate = exerciseVC.viewModel
        }
        exerciseVC.present(durationPicker, animated: true, completion: nil)
    }
    
    func exerciseFinished() {
        historyManager.addExperience()
        afterExerciseVC = storyboard.instantiateViewController(withIdentifier: "AfterExerciseViewController") as! AfterExerciseViewController
        afterExerciseVC.delegate = self
        exerciseVC.present(afterExerciseVC, animated: true, completion: nil)
    }
}

extension ExerciseCoodinator: AfterExerciseViewControllerDelegate {
    
    func didPickFeeling(_ feeling: AfterFeelingType) {
        
        if feeling == .notSelected {
            historyManager.addAfterFeeling(type: .notSelected, text: nil)
            presentingVC.dismiss(animated: true, completion: nil)
        } else {
            if feeling == .custom {
                let vc = storyboard.instantiateViewController(withIdentifier: "CustomFeelingViewController") as! CustomFeelingViewController
                vc.delegate = self
                vc.experience = historyManager.currentExperience()!
                let navVC = UINavigationController(rootViewController: vc)
                afterExerciseVC.present(navVC, animated: true, completion: nil)
            } else {
                historyManager.addAfterFeeling(type: feeling, text: nil)
                presentingVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension ExerciseCoodinator: CustomFeelingViewControllerDelegate {
    
    func didEnter(feeling: String, for experience: Experience) {
        historyManager.addAfterFeeling(type: .custom, text: feeling)
        presentingVC.dismiss(animated: true, completion: nil)
    }

}
