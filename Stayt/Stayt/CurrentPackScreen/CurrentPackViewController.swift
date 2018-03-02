//
//  CurrentPackViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class CurrentPackViewController: UIViewController {

    @IBOutlet var packNameLabel: UILabel!
    @IBOutlet var currentExerciseLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    var exercisePack: ExercisePack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        packNameLabel.text = exercisePack.name
        currentExerciseLabel.text = exercisePack.exercises[exercisePack.currentExerciseNumber].descriptionName
        dayLabel.text = "Day \(exercisePack.currentExerciseNumber + 1) \\ \(exercisePack.exercises.count)"
    }

    @IBAction func startButtonAction(_ sender: Any) {
        let coordinator = ExerciseCoodinator(exercise: exercisePack.exercises[exercisePack.currentExerciseNumber], presentingVC: self, exercisePack: exercisePack)
        coordinator.start()
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ExerciseDescriptionViewController") as! ExerciseDescriptionViewController
        vc.exerciseTitle = exercisePack.name
        vc.exerciseDescription = exercisePack.exerciseDescription
        present(vc, animated: true, completion: nil)
    }
    
}
