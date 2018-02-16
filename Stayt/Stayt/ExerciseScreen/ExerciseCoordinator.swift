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
    
    fileprivate var exerciseVC: ExerciseViewController!
    fileprivate var afterExerciseVC: AfterExerciseViewController!
    fileprivate let historyManager: HistoryManager!
    
    fileprivate var singleExerciseVC: SingleExerciseViewController!
    
    init(exercise: Exercise, presentingVC: UIViewController) {
        self.exercise = exercise
        self.presentingVC = presentingVC
        self.historyManager = HistoryManager(exercise: exercise)
    }
    
    func start() {
//        exerciseVC = storyboard.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
//        exerciseVC.exercise = exercise
//        exerciseVC.delegate = self
//        presentingVC.present(exerciseVC!, animated: true, completion: nil)
        singleExerciseVC = storyboard.instantiateViewController(withIdentifier: "SingleExerciseViewController") as! SingleExerciseViewController
        let exerciseViewModel = ExerciseViewModel(exercise: exercise, coordinationDelegate: self, delegate: singleExerciseVC)
        singleExerciseVC.viewModel = exerciseViewModel
        presentingVC.present(singleExerciseVC, animated: true, completion: nil)
    }
    
}

extension ExerciseCoodinator: ExerciseViewModelCoordinationDelegate {
    
    func showInfoScreen() {
        let vc = storyboard.instantiateViewController(withIdentifier: "ExerciseDescriptionViewController") as! ExerciseDescriptionViewController
        vc.exerciseTitle = exercise.descriptionName
        vc.exerciseDescription = exercise.description
        singleExerciseVC.present(vc, animated: true, completion: nil)
    }
    
    func dismiss() {
        presentingVC.dismiss(animated: true, completion: nil)
    }
    
    func showDurationPicker() {
        let durationPicker = storyboard.instantiateViewController(withIdentifier: "DurationPickerViewController") as! DurationPickerViewController
        durationPicker.delegate = singleExerciseVC.viewModel
        durationPicker.feeling = exercise.feelings.first!
        singleExerciseVC.present(durationPicker, animated: true, completion: nil)
    }
    
}

extension ExerciseCoodinator: ExerciseViewControllerDelegate {
    
    func didFinishExercise() {
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
