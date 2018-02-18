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
    func showDurationPicker(for activity: Feeling)
    func exerciseFinished()
}

enum ExerciseViewModelState {
    case play, pause, initial, done
}

class ExerciseViewModel: NSObject, AVAudioPlayerDelegate {
    
    var state = ExerciseViewModelState.initial
    var timer = Timer()
    var remainingDuration: Int?
    var player: AVAudioPlayer!
    let exercise: Exercise
    var coordinationDelegate: ExerciseViewModelCoordinationDelegate?
    var currentActivityNumber: Int?
    
    var title: String {
        return exercise.descriptionName
    }
    
    init(exercise: Exercise, coordinationDelegate: ExerciseViewModelCoordinationDelegate) {
        self.exercise = exercise
        self.coordinationDelegate = coordinationDelegate
    }
    
    func playButtonAction() {
        if state == .initial || state == .pause {
            if remainingDuration == nil {
                currentActivityNumber = 0
                remainingDuration = exercise.feelings.first!.duration
            }
            state = .play
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else if state == .play {
            state = .pause
            timer.invalidate()
        }
    }
    
    func playSound() {
        let soundPath = Bundle.main.path(forResource: "meditationBell", ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        player.delegate = self
        player.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if state == .done {
            coordinationDelegate?.exerciseFinished()
        }
    }
    
    @objc func updateTimer() {
        print("Override updateTimer")
    }
    
    func dismiss() {
        coordinationDelegate?.dismiss(shouldConfirm: state == .play) {
            self.timer.invalidate()
        }
    }
    
    func showInfo() {
        coordinationDelegate?.showInfoScreen()
    }
}
