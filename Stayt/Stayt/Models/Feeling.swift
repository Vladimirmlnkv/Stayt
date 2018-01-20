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
    
    init(name: String, duration: Int=10) {
        self.name = name
        self.duration = duration
    }
}

