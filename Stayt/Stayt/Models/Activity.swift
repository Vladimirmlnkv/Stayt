//
//  Feeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {
    @objc dynamic var name: String!
    @objc dynamic var duration: Int = 0
    let avaliableDurations = List<Int>()
    @objc dynamic var descriptionName: String!
    @objc dynamic var allowsEditDuration: Bool = true
    let stages = List<ActivityStage>()
    @objc dynamic var stagesTitle: String?
    var durationString: String {
        return "\(duration / 60)"
    }
    
    convenience init(name: String, duration: Int=600, descriptionName: String, stages: [ActivityStage]?=nil, avaliableDurations: [Int]?=nil, allowsEditDuration: Bool=true) {
        self.init()
        self.allowsEditDuration = allowsEditDuration
        self.name = name
        self.duration = duration
        self.descriptionName = descriptionName
        if let s = stages {
            self.stages.append(objectsIn: s)
        }
        if let durations = avaliableDurations {
            self.avaliableDurations.append(objectsIn: durations)
        }
    }
}

