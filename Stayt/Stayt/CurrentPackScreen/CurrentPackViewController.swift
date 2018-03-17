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
    @IBOutlet var startButton: UIButton!
    
    var exercisePack: ExercisePack!
    fileprivate var completedPackView: CompletedPackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        startButton.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if exercisePack.isCompleted {
            if completedPackView == nil {
                completedPackView = CompletedPackView(frame: view.frame)
                completedPackView!.delegate = self
                view.addSubview(completedPackView!)
                NSLayoutConstraint.activate([
                    completedPackView!.topAnchor.constraint(equalTo: view.topAnchor),
                    completedPackView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    completedPackView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    completedPackView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
            }
        } else {
            setupUI()
        }
    }
    
    fileprivate func setupUI() {
        packNameLabel.text = exercisePack.name
        currentExerciseLabel.text = exercisePack.exercises[exercisePack.currentExerciseNumber].descriptionName
        dayLabel.text = "Day \(exercisePack.currentExerciseNumber + 1) of \(exercisePack.exercises.count)"
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

extension CurrentPackViewController: CompletedPackViewDelegate {
    
    func startOver() {
        try! mainRealm.write {
            exercisePack.currentExerciseNumber = 0
            exercisePack.isCompleted = false
        }
        setupUI()
        completedPackView!.removeFromSuperview()
    }
    
}
