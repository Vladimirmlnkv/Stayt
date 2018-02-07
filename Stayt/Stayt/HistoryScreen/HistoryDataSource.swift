//
//  HistoryDataSource.swift
//  Stayt
//
//  Created by Владимир Мельников on 07/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryDataSource {

    let realm = mainRealm
    
    func getItems() -> [HistoryItem] {
        let results = realm.objects(HistoryItem.self)
        return Array(results)
    }
}
