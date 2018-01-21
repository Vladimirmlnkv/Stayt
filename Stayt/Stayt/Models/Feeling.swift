//
//  Feeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

struct Feeling {
    let name: String
    var duration: Int
    
    var durationString: String {
        return "\(duration / 60)"
    }
    
    init(name: String, duration: Int=600) {
        self.name = name
        self.duration = duration
    }
}

