//
//  ExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

enum ExerciseState {
    case pause, playing, initial
}

class ExerciseViewController: UIViewController {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var circleButtonView: BorderedCircleView!
    @IBOutlet var containerView: UIView!
    
    fileprivate var menuHandler: DropDownMenuHandler!
    var exercise: Exercise!
    
    fileprivate var currentFeelingNumber: Int?
    fileprivate var isSingleTimer: Bool {
        return exercise.feelings.count == 1
    }

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
        } else if state == .pause || state == .initial {
            state = .playing
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
            singleTimerView!.durationButton.setTitle("\(duration) min", for: .normal)
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
        cell.durationButton.setTitle("\(feeling.duration) min", for: .normal)
        
        if state == .initial {
            cell.durationButton.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
        } else {
            cell.durationButton.setImage(nil, for: .normal)
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
