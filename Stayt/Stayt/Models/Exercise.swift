//
//  Exercise.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Exercise {
    let name: String
    let description: String
    let descriptionName: String
    var feelings: [Feeling]
    
    init (name: String, description: String, descriptionName: String, feelings: [Feeling]) {
        self.name = name
        self.description = description
        self.feelings = feelings
        self.descriptionName = descriptionName
    }
}
