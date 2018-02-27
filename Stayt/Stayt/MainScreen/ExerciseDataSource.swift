//
//  ExerciseDataSource.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class ExerciseDataSource {
    
    fileprivate let realm = mainRealm
    
    func getExercises() -> [Exercise] {
        
        let exersises = realm.objects(Exercise.self)
        if exersises.isEmpty {
            return initialExercises()
        } else {
            return Array(exersises)
        }
    }
    
    fileprivate func initialExercises() -> [Exercise] {
        let ex1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "meditation")])
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "breathwork")])
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "arm holding")])
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation"),
                                                                                                                                                                                                                 Activity(name: "Energized", duration: 120, descriptionName: "Breathwork"),
                                                                                                                                                                                                                 Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding")])
        let exercises = [ex1, ex2, ex3, ex4]
        try! realm.write {
            realm.add(exercises)
        }
        return exercises
    }
    
}
