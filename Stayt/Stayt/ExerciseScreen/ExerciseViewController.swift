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
    @IBOutlet var circleButtonView: BorderedCircleView!
    @IBOutlet var containerView: UIView!
    
    fileprivate var menuHandler: DropDownMenuHandler!
    var feelings: [Feeling]!
    fileprivate var isSingleTimer: Bool {
        return feelings.count == 1
    }

    fileprivate var state: ExerciseState = .pause {
        didSet {
            if let singleView = singleTimerView {
                singleView.durationButton.isEnabled = false
                singleView.durationButton.setTitleColor(UIColor.gray, for: .normal)
                singleView.hideRemaining(false)
                singleView.durationButton.isHidden = true
                if state == .playing {
                    singleView.spinner.startAnimating()
                } else {
                    singleView.spinner.stopAnimating()
                }
            }
            if state == .pause {
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if state == .playing {
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    fileprivate var singleTimerView: SingleTimerView?
    fileprivate var multipleTimersView: MultipleTimersView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSingleTimer {
            singleTimerView = SingleTimerView(frame: containerView.bounds)
            singleTimerView!.hideRemaining(true)
            containerView.addSubview(singleTimerView!)
            menuHandler = DropDownMenuHandler(superView: view, triggerButtons: [singleTimerView!.durationButton])
        }
        
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
    
    func currentDuration(for tag: Int) -> Int {
        return feelings[tag].duration
    }
    
    func didChange(duration: Int, at tag: Int) {
        if isSingleTimer {
            feelings[0].duration = duration
            singleTimerView!.durationButton.setTitle("\(duration) min", for: .normal)
        } else {
            
        }
        menuHandler.hideMenu()
    }
    
}
