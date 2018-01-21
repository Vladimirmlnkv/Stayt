//
//  ExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import AVFoundation

enum ExerciseState {
    case pause, playing, initial
}

class ExerciseViewController: UIViewController, TimerDisplay {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var circleButtonView: BorderedCircleView!
    @IBOutlet var containerView: UIView!
    
    fileprivate var menuHandler: DropDownMenuHandler!
    var exercise: Exercise!
    
    fileprivate var timer = Timer()
    fileprivate var currentFeelingNumber: Int?
    fileprivate var currentDuration: Int?
    fileprivate var isSingleTimer: Bool {
        return exercise.feelings.count == 1
    }
    fileprivate var player: AVAudioPlayer!

    fileprivate var state: ExerciseState = .initial {
        didSet {
            if state == .pause {
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if state == .playing {
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                if currentFeelingNumber == nil {
                   currentFeelingNumber = 0
                }
            }
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
            } else if let multipleView = multipleTimersView {
                multipleView.tableView.reloadData()
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
            menuHandler.delegate = self
        } else {
            menuHandler = DropDownMenuHandler(superView: view, triggerButtons: [])
            menuHandler.delegate = self
            multipleTimersView = MultipleTimersView(frame: containerView.bounds)
            multipleTimersView?.tableView.tableFooterView = UIView()
            multipleTimersView!.tableView.delegate = self
            multipleTimersView!.tableView.dataSource = self
            containerView.addSubview(multipleTimersView!)
        }
    }

    
    @IBAction func playButtonAction(_ sender: Any) {
        if state == .playing {
            state = .pause
            timer.invalidate()
        } else if state == .pause || state == .initial {
            if currentDuration == nil {
                currentDuration = exercise.feelings.first?.duration
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            state = .playing
            updateCurrentLabel()
        }
    }
    
    @objc func updateTimer() {
        if let _ = currentDuration {
            currentDuration! -= 1
            
            if currentDuration == 0 {
                let soundPath = Bundle.main.path(forResource: "meditationBell", ofType: "mp3")
                player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                player.play()
            }

            if currentDuration == -1 {
                if currentFeelingNumber! < exercise.feelings.count - 1 {
                    currentFeelingNumber! += 1
                    currentDuration = exercise.feelings[currentFeelingNumber!].duration
                    multipleTimersView!.tableView.reloadRows(at: [IndexPath(row: currentFeelingNumber! - 1, section: 0)], with: .automatic)
                    updateCurrentLabel()
                } else {
                    timer.invalidate()
                    if let singleView = singleTimerView {
                        singleView.spinner.isHidden = true
                        singleView.label.text = "Done"
                    }
                }
            } else {
                updateCurrentLabel()
            }
        }
    }
    
    fileprivate func updateCurrentLabel() {
        if isSingleTimer {
            singleTimerView!.label.text = "\(stringDuration(from: currentDuration!)) remaining"
        } else {
            multipleTimersView!.tableView.beginUpdates()
            multipleTimersView!.tableView.reloadRows(at: [IndexPath(row: currentFeelingNumber!, section: 0)], with: .automatic)
            multipleTimersView!.tableView.endUpdates()
        }
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ExerciseViewController: MenuDelegate {
    
    func currentDuration(for tag: Int) -> Int {
        return exercise.feelings[tag].duration
    }
    
    func didChange(duration: Int, at tag: Int) {
        exercise.feelings[tag].duration = duration
        if isSingleTimer {
            singleTimerView!.durationButton.setTitle("\(duration / 60) min", for: .normal)
        } else {
            multipleTimersView!.tableView.reloadData()
        }
        menuHandler.hideMenu()
    }
    
}

extension ExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.feelings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feeling = exercise.feelings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelingTimerCell") as! FeelingTimerCell
        cell.durationButton.tag = indexPath.row
        cell.label.text = feeling.name
        if indexPath.row == currentFeelingNumber {
            let duration = stringDuration(from: currentDuration!)
            cell.durationButton.setTitle(duration, for: .normal)
        } else {
            cell.durationButton.setTitle("\(feeling.durationString) min", for: .normal)
        }
        
        if state == .initial {
            cell.durationButton.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
            cell.durationButton.isUserInteractionEnabled = true
        } else {
            cell.durationButton.setImage(nil, for: .normal)
            cell.durationButton.isUserInteractionEnabled = false
        }
        
        if let currentFeelingNumber = currentFeelingNumber, indexPath.row < currentFeelingNumber {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        menuHandler.addButton(button: cell.durationButton)
        
        if state == .playing && indexPath.row == currentFeelingNumber {
            cell.spinner.isHidden = false
            cell.spinner.startAnimating()
        } else {
            cell.spinner.isHidden = true
            cell.spinner.stopAnimating()
        }
        
        return cell
    }
    
}

extension ExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
