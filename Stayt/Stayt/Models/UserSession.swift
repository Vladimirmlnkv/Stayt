//
//  UserSession.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import RealmSwift

class UserSession: Object {
    
    @objc dynamic var recentExercise: Exercise?
    
}
