//
//  AfterFeeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 13/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import RealmSwift

enum AfterFeelingType: String {
    case muchBetter, aBitBetter, noDifferent, worse, custom, notSelected
    
    var title: String {
        switch self {
        case .muchBetter:
            return "Much better"
        case .aBitBetter:
            return "A bit better"
        case .noDifferent:
            return "No different"
        case .worse:
            return "Worse"
        case .custom:
            return "Write your own version"
        case .notSelected:
            return "Prefer not to say"
        }
    }
}

class AfterFeeling: Object {
    
    @objc dynamic var rawType: String!
    @objc dynamic var text: String?
    
    var type: AfterFeelingType {
        return AfterFeelingType(rawValue: rawType)!
    }
    
    convenience init(type: AfterFeelingType, text: String?=nil) {
        self.init()
        rawType = type.rawValue
        self.text = text
    }
}
