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
        
        let day1Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: "Benefits Of Meditation", isGuided: true, activities: [Activity(name: "Relaxed", duration: 120, descriptionName: "Meditation", avaliableDurations: [60, 120, 240], guidance: [Guidance(duration: 60, fileName: "Level1(1min)"), Guidance(duration: 120, fileName: "Level1(2min)"), Guidance(duration: 240, fileName: "Level1(4min)")])])
        
        day1Meditation.shouldShowTutorialFirst = true

        let rapidStage1 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [60], allowsEditDuration: false)
        rapidStage1.guidanceList.append(Guidance(duration: 60, fileName: "Level2Part1"))
        let outholdStage1 = ActivityStage(name: "Out/Hold", duration: 15, avaliableDurations: [15], allowsEditDuration: false)
        outholdStage1.guidanceList.append(Guidance(duration: 15, fileName: "Level2Part2"))
        let inholdStage1 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15], allowsEditDuration: false)
        inholdStage1.guidanceList.append(Guidance(duration: 15, fileName: "Level2Part3"))
        let stages1 = [rapidStage1, outholdStage1, inholdStage1]
        
        let breathworkActivity = Activity(name: "Energized", duration: 90, descriptionName: "Breathwork", stages: stages1)
        breathworkActivity.stagesTitle = "Breathwork contains different stages. You'll be able to change their durations in next sessions of this pack"
        
        let day2Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: "Understanding Breathwork", isGuided: true, activities: [breathworkActivity])
        day2Breathwork.shouldShowTutorialFirst = true
        
        let day3ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: "Learning the Arm Hold", isGuided: true, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding", avaliableDurations: [60, 120, 240], guidance: [Guidance(duration: 60, fileName: "Level3(1min)"), Guidance(duration: 120, fileName: "Level3(2min)"), Guidance(duration: 240, fileName: "Level3(4min)")])])
        day3ArmHolding.shouldShowTutorialFirst = true
        
        let day4Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: "Basics of Meditation", isGuided: true, activities: [Activity(name: "Relaxed", duration: 240, descriptionName: "Meditation", avaliableDurations: [120, 240, 300])])
        
        let rapidStage2 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [60], allowsEditDuration: false)
        let outholdStage2 = ActivityStage(name: "Out/Hold", duration: 30, avaliableDurations: [15, 30])
        let inholdStage2 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15], allowsEditDuration: false)
        let stages2 = [rapidStage2, outholdStage2, inholdStage2]
        
        let day5Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: "Breathwork Practice", isGuided: true, activities: [Activity(name: "Energized", duration: 105, descriptionName: "Breathwork", stages: stages2)])
        
        let day6ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: "Mindset for Armhold", isGuided: true, activities: [Activity(name: "Motivated", duration: 240, descriptionName: "Arm holding", avaliableDurations: [120, 240, 300])])
        
        let day7Meditation = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: "Deep in Meditation", isGuided: true, activities: [Activity(name: "Relaxed", duration: 300, descriptionName: "Meditation", avaliableDurations: [120, 240, 300, 600])])
        
        let rapidStage3 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [60], allowsEditDuration: false)
        let outholdStage3 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [15, 30, 45])
        let inholdStage3 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15])
        let stages3 = [rapidStage3, outholdStage3, inholdStage3]
        
        let day8Breathwork = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: "Fun with Breathwork", isGuided: true, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages3)])
        
        let day9ArmHolding = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: "Arm Hold Challenge", isGuided: true, activities: [Activity(name: "Motivated", duration: 300, descriptionName: "Arm holding", avaliableDurations: [120, 240, 300, 360])])
        
        let day10Combo = Exercise(name: "Combo", description: ExerciseDescription.blessingDescription, descriptionName: "Combo Session", isGuided: true, activities: [ Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding", allowsEditDuration: false),                                                                                                                                                                                                                 Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages3, allowsEditDuration: false), Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation", allowsEditDuration: false),])
        
        let difficulties = [
            Difficulty(name: "Beginner", durations: [
                DifficultyDuration(duration: 120),
                DifficultyDuration(duration: 90, stagesDurations: [60, 15 ,15]),
                DifficultyDuration(duration: 300)
            ]),
            Difficulty(name: "Intermediate", durations: [
                DifficultyDuration(duration: 300),
                DifficultyDuration(duration: 105, stagesDurations: [60, 30 ,15]),
                DifficultyDuration(duration: 300)
            ]),
            Difficulty(name: "Advanced", durations: [
                DifficultyDuration(duration: 600),
                DifficultyDuration(duration: 120, stagesDurations: [60, 45 ,15]),
                DifficultyDuration(duration: 600)
            ])
        ]
        day10Combo.difficulties.append(objectsIn: difficulties)
        day10Combo.selectedDifficulty = difficulties[1]
        
        let description = "This begginer exercise pack is an intruduction to state changers. You'll be introduced to meditation, breathwork and arm holding. On day 10 you'll get to try a combo exercise that contains meditation, breathwork and arm holding. The goal here is to get comfortable doing state changers and see how they make you feel."
        
        let beginnerPack = ExercisePack(name: "Introduction pack", exercises: [day1Meditation, day2Breathwork, day3ArmHolding, day4Meditation, day5Breathwork, day6ArmHolding, day7Meditation, day8Breathwork, day9ArmHolding, day10Combo], exerciseDescription: description)
        try! realm.write {
            realm.add(beginnerPack)
        }
        
        return beginnerPack
    }
    
    func getExercises() -> [Exercise] {
        
        let exersises = realm.objects(Exercise.self).filter({!$0.isGuided})
        if exersises.isEmpty {
            return initialExercises()
        } else {
            return Array(exersises)
        }
    }
    
    fileprivate func initialExercises() -> [Exercise] {
        
        let ex1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation")])
        ex1.allowsRounds = true
        ex1.roundsRestTimes.append(objectsIn: [60, 120, 300])
        ex1.defaultRestTime = 60
        
        let rapidStage = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60])
        let outholdStage = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45])
        let inholdStage = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages = [rapidStage, outholdStage, inholdStage]
        
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages)])
        ex2.allowsRounds = true
        ex2.roundsRestTimes.append(objectsIn: [0, 60, 120, 300])
        
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding")])
        ex3.allowsRounds = true
        ex3.roundsRestTimes.append(objectsIn: [60, 120, 300])
        ex3.defaultRestTime = 60
        
        let rapidStage1 = ActivityStage(name: "Rapid breathing", duration: 60, avaliableDurations: [40, 50, 60, 70, 80, 90, 100, 110, 120])
        let outholdStage1 = ActivityStage(name: "Out/Hold", duration: 45, avaliableDurations: [30, 40, 45, 50, 60, 70, 80, 90, 100])
        let inholdStage1 = ActivityStage(name: "In/Hold", duration: 15, avaliableDurations: [15, 20, 25, 30, 35, 40, 45, 50, 60])
        let stages1 = [rapidStage1, outholdStage1, inholdStage1]
        
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: "Combo Session", isGuided: false, activities: [Activity(name: "Relaxed", duration: 180, descriptionName: "Meditation"),
                                                                                                                                                                                                                 Activity(name: "Energized", duration: 120, descriptionName: "Breathwork", stages: stages1),
                                                                                                                                                                                                                 Activity(name: "Motivated", duration: 120, descriptionName: "Arm holding")])
        ex4.allowsRounds = true
        ex4.roundsRestTimes.append(objectsIn: [0 ,60, 120, 300])
        ex4.allowsReorderActivities = true
        
        let exercises = [ex1, ex2, ex3, ex4]
        try! realm.write {
            realm.add(exercises)
        }
        return exercises
    }
    
}
