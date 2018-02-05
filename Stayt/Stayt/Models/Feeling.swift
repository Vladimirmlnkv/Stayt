//
//  Feeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Feeling {
    let name: String
    var duration: Int
    let descriptionName: String
    var durationString: String {
        return "\(duration / 60)"
    }
    
    init(name: String, duration: Int=600, descriptionName: String) {
        self.name = name
        self.duration = duration
        self.descriptionName = descriptionName
    }
}

