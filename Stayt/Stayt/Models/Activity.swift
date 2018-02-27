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
    @objc dynamic var descriptionName: String!
    var durationString: String {
        return "\(duration / 60)"
    }
    
    convenience init(name: String, duration: Int=600, descriptionName: String) {
        self.init()
        self.name = name
        self.duration = duration
        self.descriptionName = descriptionName
    }
}

