//
//  UserSessionHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class UserSessionHandler {
    
    static let standart = UserSessionHandler()
    
    func getSession() -> UserSession? {
        return mainRealm.objects(UserSession.self).first
    }
    
    func setRecentExercise(_ exercise: Exercise) {
        try! mainRealm.write {
            if let session = getSession() {
                session.recentExercise = exercise
            } else {
                let newSession = UserSession()
                newSession.recentExercise = exercise
                mainRealm.add(newSession)
            }
        }
    }
}
