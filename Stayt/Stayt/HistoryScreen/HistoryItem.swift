//
//  HistoryItem.swift
//  Stayt
//
//  Created by Владимир Мельников on 07/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class Experience: Object {
    
    @objc dynamic var exsersiseName: String!
    @objc dynamic var feelingAfter: String?
    @objc dynamic var duration: Int = 0
    
    convenience init(name: String, feeling: String?, duration: Int) {
        self.init()
        self.exsersiseName = name
        self.feelingAfter = feeling
        self.duration = duration
    }
}

class HistoryItem: Object {
    
    @objc dynamic var date: Date!
    let experiences = List<Experience>()
    
    convenience init(date: Date, experiences: [Experience]) {
        self.init()
        self.date = date
        self.experiences.append(objectsIn: experiences)
    }
    
}
