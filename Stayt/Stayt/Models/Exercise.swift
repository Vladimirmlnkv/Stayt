//
//  Exercise.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class DifficultyDuration: Object {
    @objc dynamic var duration: Int = 0
    let stagesDurations = List<Int>()
    
    convenience init(duration: Int, stagesDurations: [Int]?=nil) {
        self.init()
        self.duration = duration
        if let durations = stagesDurations {
            self.stagesDurations.append(objectsIn: durations)
        }
    }
}

class Difficulty: Object {
    @objc dynamic var name: String!
    let durations = List<DifficultyDuration>()
    
    convenience init(name: String, durations: [DifficultyDuration]) {
        self.init()
        self.name = name
        self.durations.append(objectsIn: durations)
    }
}

class Exercise: Object {
    
    @objc dynamic var name: String!
    @objc dynamic var descriptionText: String!
    @objc dynamic var descriptionName: String!
    let activities = List<Activity>()
    @objc dynamic var isGuided: Bool = false
    
    @objc dynamic var allowsRounds: Bool = false
    @objc dynamic var defaultRestTime: Int = 0
    let roundsRestTimes = List<Int>()
    @objc dynamic var allowsReorderActivities: Bool = false
    @objc dynamic var shouldShowTutorialFirst: Bool = false
    
    let difficulties = List<Difficulty>()
    @objc dynamic var selectedDifficulty: Difficulty?
    
    convenience init (name: String, description: String, descriptionName: String, isGuided: Bool, activities: [Activity]) {
        self.init()
        self.name = name
        self.descriptionText = description
        self.activities.append(objectsIn: activities)
        self.descriptionName = descriptionName
        self.isGuided = isGuided
    }
}
