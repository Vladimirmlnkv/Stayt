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
    @IBOutlet var recentActivityLabel: UILabel!
    fileprivate var recentExercise: Exercise?
    
    var sections = [ExerciseSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "question-mark"), style: .done, target: self, action: #selector(aboutAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.white
        let ex1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", descriptionName: "meditation")])
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", descriptionName: "breathwork")])
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", descriptionName: "arm holding")])
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, activities: [Activity(name: "Relaxed", descriptionName: "Meditation"),
                                                                                                                                                                                                                                                        Activity(name: "Energized", descriptionName: "Breathwork"),
                                                                                                                                                                                                                                                        Activity(name: "Motivated", descriptionName: "Arm holding")])
        let exercises = [ex1, ex2, ex3, ex4]
        let firstSection = ExerciseSection(name: "Unguided singles", exercises: exercises, delegate: self)
        sections.append(firstSection)
        firstSection.layout(on: scrollViewContentView, topAnchor: mostRecentView.bottomAnchor)
        
        let gEx1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: true, activities: [Activity(name: "Relaxed", descriptionName: "meditation")])
        let gEx2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: true, activities: [Activity(name: "Energized", descriptionName: "breathwork")])
        let gEx3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: true, activities: [Activity(name: "Motivated", descriptionName: "arm holding")])
        let gEx4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: true, activities: [Activity(name: "Relaxed", descriptionName: "Meditation"),
                                                                                                                                                                                                               Activity(name: "Energized", descriptionName: "Breathwork"),
                                                                                                                                                                                                               Activity(name: "Motivated", descriptionName: "Arm holding")])
        let guidedExercises = [gEx1, gEx2, gEx3, gEx4]
        let secondSection = ExerciseSection(name: "Guided singles", exercises: guidedExercises, delegate: self)
        secondSection.layout(on: scrollViewContentView, topAnchor: firstSection.exerciseSectionView.bottomAnchor)
        sections.append(secondSection)
        
    }
    
    @objc func aboutAction() {
        let aboutVC = storyboard!.instantiateViewController(withIdentifier: "AboutViewController")
        present(aboutVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let session = UserSessionHandler.standart.getSession(), let e = session.recentExercise {
            recentExercise = e
            let text = e.isGuided ? "Guided " : "Unguided "
            recentActivityLabel.text = text + e.descriptionName.lowercased()
            recentViewHeightConstraint.constant = 1/3 * view.frame.height
        } else {
            recentActivityLabel.text = nil
            recentExercise = nil
            recentViewHeightConstraint.constant = 0
        }
    }

    @IBAction func startRecentActivityAction(_ sender: Any) {
        if let e = recentExercise {
            let coordinator = ExerciseCoodinator(exercise: e, presentingVC: self)
            coordinator.start()
        }
    }
}

extension BaseViewController: ExerciseSectionDelegate {
    
    func didSelect(exercise: Exercise) {
        let coordinator = ExerciseCoodinator(exercise: exercise, presentingVC: self)
        coordinator.start()
    }
    
}
