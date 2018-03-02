//
//  ExerciseViewModel.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

import AVKit

protocol ExerciseViewModelCoordinationDelegate: class {
    func showInfoScreen()
    func dismiss(shouldConfirm: Bool, completion: @escaping () -> Void)
    func showDurationPicker(with title: String, currentDuration: Int?, allowedDurations: [Int]?, completion: @escaping (Int) -> Void)
    func showStagesScreen(for activity: Activity)
    func exerciseFinished(roundsCount: Int)
    func endExecrise(with roundsCount: Int, completion: @escaping () -> Void)
}

enum ExerciseViewModelState {
    case play, pause, initial, done
}

class ExerciseViewModel: NSObject, AVAudioPlayerDelegate {
    
    var state = ExerciseViewModelState.initial
    var currentTimeDuration: Int?
    var player: AVPlayer?
    var endSoundPlayer: AVAudioPlayer!
    let exercise: Exercise
    var coordinationDelegate: ExerciseViewModelCoordinationDelegate?
    var currentActivityNumber: Int?
    var currentStage: Int?
    let exercisePack: ExercisePack?
    
    var title: String {
        return exercise.descriptionName
    }
    
    //Override
    var updateBlock: ((CMTime) -> Void)!
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate, exercisePack: ExercisePack?) {
        self.exercise = exercise
        self.coordinationDelegate = coordinationDelegate
        self.exercisePack = exercisePack
    }
    
    func playButtonAction() {
        if state == .initial || state == .pause {
            if currentTimeDuration == nil {
                currentActivityNumber = 0
                if !exercise.activities.first!.stages.isEmpty {
                    currentStage = 0
                    currentTimeDuration = exercise.activities.first!.stages.first!.duration
                } else {
                    currentTimeDuration = exercise.activities.first!.duration
                }
            }
            state = .play
            if let player = player {
                player.play()
            } else {
                let soundPath = Bundle.main.path(forResource: "empty", ofType: "mp3")
                let interval = CMTime(seconds: 1, preferredTimescale: 1)
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
                try! AVAudioSession.sharedInstance().setActive(true)
                player = AVPlayer(url: URL(fileURLWithPath: soundPath!))
                player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: updateBlock)
                player!.play()
            }
        } else if state == .play {
            state = .pause
            player?.pause()
        }
    }
    
    func titleForActivityDuration(from activity: Activity) -> String {
        return "Select duration of \(activity.descriptionName.lowercased())"
    }
    
    func playSound() {
        let soundPath = Bundle.main.path(forResource: "meditationBell", ofType: "mp3")
        endSoundPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
        endSoundPlayer.delegate = self
        endSoundPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if state == .done {
            incrementCurrentExerciseInPack()
            coordinationDelegate?.exerciseFinished(roundsCount: 1)
        }
    }
    
    func dismiss() {
        coordinationDelegate?.dismiss(shouldConfirm: state == .play) {
            self.player?.pause()
        }
    }
    
    func showInfo() {
        coordinationDelegate?.showInfoScreen()
    }
    
    func incrementCurrentExerciseInPack() {
        if exercisePack != nil {
            try! mainRealm.write {
                if exercisePack!.currentExerciseNumber < exercisePack!.exercises.count - 1 {
                    exercisePack!.currentExerciseNumber += 1
                } else {
                    exercisePack!.isCompleted = true
                }
            }
        }
    }
}
