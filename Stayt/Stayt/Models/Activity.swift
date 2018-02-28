//
//  Feeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class ActivityStage: Object {
    
    @objc dynamic var name: String!
    @objc dynamic var duration: Int = 0
    let avaliableDurations = List<Int>()
    convenience init(name: String, duration: Int, avaliableDurations: [Int]) {
        self.init()
        self.name = name
        self.duration = duration
        self.avaliableDurations.append(objectsIn: avaliableDurations)
    }
}

class Activity: Object {
    @objc dynamic var name: String!
    @objc dynamic var duration: Int = 0
    @objc dynamic var descriptionName: String!
    let stages = List<ActivityStage>()
    var durationString: String {
        return "\(duration / 60)"
    }
    
    convenience init(name: String, duration: Int=600, descriptionName: String, stages: [ActivityStage]?=nil) {
        self.init()
        self.name = name
        self.duration = duration
        self.descriptionName = descriptionName
        if let s = stages {
            self.stages.append(objectsIn: s)
        }
    }
}

