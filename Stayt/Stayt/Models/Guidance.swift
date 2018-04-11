//
//  Guidance.swift
//  Stayt
//
//  Created by Владимир Мельников on 10/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class Guidance: Object {
    @objc dynamic var duration: Int = 0
    @objc dynamic var fileName: String!
    
    convenience init(duration: Int, fileName: String) {
        self.init()
        self.duration = duration
        self.fileName = fileName
    }
}
