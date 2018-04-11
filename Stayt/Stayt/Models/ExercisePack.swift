//
//  ExercisePack.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import RealmSwift

class ExercisePack: Object {
    
    @objc dynamic var name: String!
    @objc dynamic var exerciseDescription: String!
    let exercises = List<Exercise>()
    
    @objc dynamic var currentExerciseNumber = 9
    @objc dynamic var isCompleted = false
    
    convenience init(name: String, exercises: [Exercise], exerciseDescription: String) {
        self.init()
        self.name = name
        self.exercises.append(objectsIn: exercises)
        self.exerciseDescription = exerciseDescription
    }
    
}
