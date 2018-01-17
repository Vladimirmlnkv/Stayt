//
//  ExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

enum ExerciseState {
    case pause, playing
}

class ExerciseViewController: UIViewController {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var durationButton: DisclosureButton!
    
    fileprivate var menuHandler: DropDownMenuHandler!
    fileprivate var duration: Int = 10 {
        didSet {
            durationButton.setTitle("\(duration) min", for: .normal)
        }
    }
    fileprivate var state: ExerciseState = .pause {
        didSet {
            if state == .pause {
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if state == .playing {
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuHandler = DropDownMenuHandler(superView: view, triggerButton: durationButton)
        menuHandler.delegate = self
    }

    
    @IBAction func playButtonAction(_ sender: Any) {
        if state == .playing {
            state = .pause
        } else if state == .pause {
            state = .playing
        }
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ExerciseViewController: MenuDelegate {
    
    var currentDuration: Int {
        return duration
    }
    
    func didChange(duration: Int) {
        self.duration = duration
        menuHandler.hideMenu()
    }
    
}
