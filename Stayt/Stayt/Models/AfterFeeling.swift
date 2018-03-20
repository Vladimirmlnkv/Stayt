//
//  AfterFeeling.swift
//  Stayt
//
//  Created by Владимир Мельников on 13/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import RealmSwift

class AfterFeeling: Object {
    
    @objc dynamic var feeling: Feeling!
    @objc dynamic var text: String?

    convenience init(feeling: Feeling, text: String?=nil) {
        self.init()
        self.feeling = feeling
        self.text = text
    }
}

class Feeling: Object {
    @objc dynamic var title: String!
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
