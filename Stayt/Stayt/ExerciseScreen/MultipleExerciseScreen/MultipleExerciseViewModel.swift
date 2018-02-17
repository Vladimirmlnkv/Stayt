//
//  MultipleExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MultipleExerciseViewModel: ExerciseViewModel {
    
    var activitiesCount: Int {
        return exercise.feelings.count
    }
    
    var activities: [Feeling] {
        return exercise.feelings
    }
    
    var allowsEditingDuration: Bool {
        return state == .initial
    }
    
    func isAcitivityCompleted(at index: Int) -> Bool {
        return true
    }
    
}

extension MultipleExerciseViewModel: SingleActivityCellDelegate {
    
    func changeDuration(for acitivity: Feeling) {
        
    }

}
