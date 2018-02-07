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
    
    init(exercise: Exercise, presentingVC: UIViewController) {
        self.exercise = exercise
        self.presentingVC = presentingVC
        self.historyManager = HistoryManager(exercise: exercise)
    }
    
    func start() {
        exerciseVC = storyboard.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
        exerciseVC.exercise = exercise
        exerciseVC.delegate = self
        presentingVC.present(exerciseVC!, animated: true, completion: nil)
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
    
    func didPickFeeling(_ feeling: String?) {
        if let f = feeling {
            historyManager.addFeeling(f)
        }
        presentingVC.dismiss(animated: true, completion: nil)
    }
    
}
