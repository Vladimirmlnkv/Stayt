//
//  TimerDuration.swift
//  Stayt
//
//  Created by Владимир Мельников on 21/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

protocol TimerDisplay {}
extension TimerDisplay {
    
    func stringDuration(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds - hours * 3600) / 60
        let seconds = totalSeconds - hours * 3600 - minutes * 60
        var result = ""
        if hours > 0 {
            result += getStringNumber(from: hours) + ":"
        }
        if !result.isEmpty || minutes > 0 {
            result += getStringNumber(from: minutes) + ":"
        }
        
        if result.isEmpty {
            result = "0:" + getStringNumber(from: seconds)
        } else {
            result += getStringNumber(from: seconds)
        }
        return result
    }
    
    func passiveStringDuration(from totalSeconds: Int, forcedInSeconds: Bool=false) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds - hours * 3600) / 60
        let seconds = totalSeconds - hours * 3600 - minutes * 60
        
        if forcedInSeconds {
            return "\(totalSeconds) sec"
        }
        
        if minutes > 0 {
            if seconds > 0 {
                return "\(minutes):\(getStringNumber(from: seconds)) min"
            } else {
               return "\(minutes) min"
            }
        } else {
            return "\(seconds) sec"
        }
    }
    
    private func getStringNumber(from number: Int) -> String {
        if number > 9 {
            return "\(number)"
        } else {
            return "0\(number)"
        }
    }
}
