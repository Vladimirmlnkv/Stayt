//
//  Exercise.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    @objc dynamic var name: String!
    @objc dynamic var descriptionText: String!
    @objc dynamic var descriptionName: String!
    let feelings = List<Feeling>()
    @objc dynamic var isGuided: Bool = false
    
    convenience init (name: String, description: String, descriptionName: String, isGuided: Bool, feelings: [Feeling]) {
        self.init()
        self.name = name
        self.descriptionText = description
        self.feelings.append(objectsIn: feelings)
        self.descriptionName = descriptionName
        self.isGuided = isGuided
    }
}
