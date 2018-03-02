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
    
    func getBeginnerPack() -> ExercisePack {
        
        if let pack = realm.objects(ExercisePack.self).first {
            return pack
        } else {
            return initBeginnersPack()
        }
    }
    
    fileprivate func initBeginnersPack() -> ExercisePack {
        
        let day1Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "meditation")])
        
        let rapidStage1 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage1 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage1 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages1 = [rapidStage1, outholdStage1, inholdStage1]
        
        let day2Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages1)])
        
        let day3ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "arm holding")])
        
        let day4Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "meditation")])
        
        let rapidStage2 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage2 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage2 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages2 = [rapidStage2, outholdStage2, inholdStage2]
        
        let day5Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages2)])
        
        let day6ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "arm holding")])
        
        let day7Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "meditation")])
        
        let rapidStage3 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage3 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage3 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages3 = [rapidStage3, outholdStage3, inholdStage3]
        
        let day8Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages3)])
        
        let day9ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "arm holding")])
        
        let day10Combo = Exercise(name: "Combo", description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation"),
                                                                                                                                                                                                                 Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages1),
                                                                                                                                                                                                                 Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding")])
        
        let description = "This begginer exercise pack is an intruduction to state changers. You'll be introduced to meditation, breathwork and arm holding. On day 10 you'll get to try a combo exercise that contains meditation, breathwork and arm holding. The goal here is to get comfortable doing state changers and see how they make you feel."
        
        let beginnerPack = ExercisePack(name: "Beginner pack", exercises: [day1Meditation, day2Breathwork, day3ArmHolding, day4Meditation, day5Breathwork, day6ArmHolding, day7Meditation, day8Breathwork, day9ArmHolding, day10Combo], exerciseDescription: description)
        try! realm.write {
            realm.add(beginnerPack)
        }
        
        return beginnerPack
    }
    
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
        
        let rapidStage = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages = [rapidStage, outholdStage, inholdStage]
        
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages)])
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "arm holding")])
        
        let rapidStage1 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage1 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage1 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages1 = [rapidStage1, outholdStage1, inholdStage1]
        
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation"),
                                                                                                                                                                                                                 Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages1),
                                                                                                                                                                                                                 Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding")])
        let exercises = [ex1, ex2, ex3, ex4]
        try! realm.write {
            realm.add(exercises)
        }
        return exercises
    }
    
}
