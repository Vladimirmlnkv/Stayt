//
//  ActivityStage.swift
//  Stayt
//
//  Created by Владимир Мельников on 10/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class ActivityStage: Object {
    
    @objc dynamic var name: String!
    @objc dynamic var duration: Int = 0
    let avaliableDurations = List<Int>()
    @objc dynamic var allowsEditDuration: Bool = true
    
    convenience init(name: String, duration: Int, avaliableDurations: [Int], allowsEditDuration: Bool=true) {
        self.init()
        self.allowsEditDuration = allowsEditDuration
        self.name = name
        self.duration = duration
        self.avaliableDurations.append(objectsIn: avaliableDurations)
    }
}

