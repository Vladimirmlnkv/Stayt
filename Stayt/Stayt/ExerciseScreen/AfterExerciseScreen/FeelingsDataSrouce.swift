//
//  FeelingsDataSrouce.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import RealmSwift

class FeelingsDataSrouce {
    
    fileprivate let realm = mainRealm
    fileprivate let standartOptionsCount = 4
    
    init() {
        if realm.objects(Feeling.self).isEmpty {
            let options = [ Feeling(title: "Relaxed"), Feeling(title: "Calm"), Feeling(title: "Energized"), Feeling(title: "Motivated")]
            try! realm.write {
                realm.add(options)
            }
        }
    }
    
    func getFeelings() -> [Feeling] {
        return Array(realm.objects(Feeling.self))
    }
    
    func add(new feeling: String) {
        let results = realm.objects(Feeling.self)
        try! realm.write {
            if results.count >= standartOptionsCount + 5 {
                let deleteItem = results[standartOptionsCount]
                realm.delete(deleteItem)
            }
            let newFeeling = Feeling(title: feeling)
            newFeeling.createdByUser = true
            realm.add(newFeeling)
        }
    }
}
