//
//  BaseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 19/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet var scrollViewContentView: UIView!
    @IBOutlet var mostRecentView: UIView!
    @IBOutlet var recentViewHeightConstraint: NSLayoutConstraint!
    
    var sections = [ExerciseSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ex1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, feelings: [Feeling(name: "Relaxed", descriptionName: "meditation")])
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, feelings: [Feeling(name: "Energized", descriptionName: "breathwork")])
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, feelings: [Feeling(name: "Motivated", descriptionName: "arm holding")])
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, feelings: [Feeling(name: "Relaxed", descriptionName: "Meditation"),
                                                                                                                                                                                                                                                        Feeling(name: "Energized", descriptionName: "Breathwork"),
                                                                                                                                                                                                                                                        Feeling(name: "Motivated", descriptionName: "Arm holding")])
        let exercises = [ex1, ex2, ex3, ex4]
        let firstSection = ExerciseSection(name: "Unguided singles", exercises: exercises, delegate: self)
        sections.append(firstSection)
        firstSection.layout(on: scrollViewContentView, topAnchor: mostRecentView.bottomAnchor)
        
        let gEx1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: true, feelings: [Feeling(name: "Relaxed", descriptionName: "meditation")])
        let gEx2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: true, feelings: [Feeling(name: "Energized", descriptionName: "breathwork")])
        let gEx3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: true, feelings: [Feeling(name: "Motivated", descriptionName: "arm holding")])
        let gEx4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: true, feelings: [Feeling(name: "Relaxed", descriptionName: "Meditation"),
                                                                                                                                                                                                               Feeling(name: "Energized", descriptionName: "Breathwork"),
                                                                                                                                                                                                               Feeling(name: "Motivated", descriptionName: "Arm holding")])
        let guidedExercises = [gEx1, gEx2, gEx3, gEx4]
        let secondSection = ExerciseSection(name: "Guided singles", exercises: guidedExercises, delegate: self)
        secondSection.layout(on: scrollViewContentView, topAnchor: firstSection.exerciseSectionView.bottomAnchor)
        sections.append(secondSection)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentViewHeightConstraint.constant = 1/3 * view.frame.height
    }

}

extension BaseViewController: ExerciseSectionDelegate {
    
    func didSelect(exercise: Exercise) {
        let coordinator = ExerciseCoodinator(exercise: exercise, presentingVC: self)
        coordinator.start()
    }
    
}
