//
//  HistoryManager.swift
//  Stayt
//
//  Created by Владимир Мельников on 07/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryManager {
    
    fileprivate let realm = mainRealm
    fileprivate let exercise: Exercise
    fileprivate var newExperience: Experience?
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func addExperience() {
        let date = Date(timeIntervalSinceNow: 0)
        let components = self.components(from: date)
        let item = realm.objects(HistoryItem.self).filter { i -> Bool in
            let itemComponents = self.components(from: i.date)
            return components.day == itemComponents.day && components.month == components.month
        }.first
        let duration = exercise.feelings.reduce(0, {$0 + $1.duration})
        newExperience = Experience(name: exercise.descriptionName, feeling: nil, duration: duration, date: date)
        if let existingItem = item {
            try! realm.write {
                existingItem.experiences.insert(self.newExperience!, at: 0)
            }
        } else {
            let item = HistoryItem(date: date, experiences: [self.newExperience!])
            try! realm.write {
                realm.add(item)
            }
        }
    }
    
    func addAfterFeeling(type: AfterFeelingType, text: String?) {
        if let experience = newExperience {
            try! realm.write {
                experience.afterFeeling = AfterFeeling(type: type, text: text)
            }
        }
    }
    
    func currentExperience() -> Experience? {
        return newExperience
    }
    
    fileprivate func components(from date: Date) -> DateComponents {
        return NSCalendar.current.dateComponents([.day, .month], from: date)
    }
}
