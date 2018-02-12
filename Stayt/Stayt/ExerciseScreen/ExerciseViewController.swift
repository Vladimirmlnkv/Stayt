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
    case pause, playing, initial, done
}

protocol ExerciseViewControllerDelegate {
    func didFinishExercise()
}

class ExerciseViewController: UIViewController, TimerDisplay {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var circleButtonView: BorderedCircleView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    var exercise: Exercise!
    
    fileprivate var timer = Timer()
    fileprivate var currentFeelingNumber: Int?
    var currentDuration: Int!
    fileprivate var isSingleTimer: Bool {
        return exercise.feelings.count == 1
    }
    fileprivate var player: AVAudioPlayer!

    fileprivate var state: ExerciseState = .initial {
        didSet {
            if state == .pause {
                UIApplication.shared.isIdleTimerDisabled = false
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if state == .playing {
                UIApplication.shared.isIdleTimerDisabled = true
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                if currentFeelingNumber == nil {
                   currentFeelingNumber = 0
                }
            }
            
            if state == .done {
                singleTimerView?.removeFromSuperview()
                singleTimerView = nil
                multipleTimersView?.removeFromSuperview()
                multipleTimersView = nil
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                playButton.isUserInteractionEnabled = false
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
                if multipleView.tableView.isEditing {
                    multipleTimersView?.tableView.setEditing(false, animated: true)
                }
                multipleView.tableView.reloadData()
            }
        }
    }
    
    fileprivate var singleTimerView: SingleTimerView?
    fileprivate var multipleTimersView: MultipleTimersView?
    fileprivate var holderHandler: HolderViewHandler?
    var delegate: ExerciseViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResingActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        titleLabel.text = exercise.descriptionName
        currentDuration = exercise.feelings.first!.duration
        if isSingleTimer {
            singleTimerView = SingleTimerView(frame: containerView.bounds)
            singleTimerView?.translatesAutoresizingMaskIntoConstraints = false
            singleTimerView?.durationButton.addTarget(self, action: #selector(singleDurationButtonAction), for: .allTouchEvents)
            singleTimerView!.hideRemaining(true)
            singleTimerView!.durationButton.setTitle("\(exercise.feelings.first!.durationString) min", for: .normal)
            containerView.addSubview(singleTimerView!)
            addConstraints(to: singleTimerView!)
        } else {
            multipleTimersView = MultipleTimersView(frame: containerView.bounds)
            multipleTimersView!.translatesAutoresizingMaskIntoConstraints = false
            multipleTimersView!.tableView.tableFooterView = UIView()
            multipleTimersView!.tableView.rowHeight = 44.0
            multipleTimersView!.tableView.delegate = self
            multipleTimersView!.tableView.dataSource = self
            multipleTimersView!.tableView.setEditing(true, animated: false)
            multipleTimersView!.tableView.bounces = false
            containerView.addSubview(multipleTimersView!)
            addConstraints(to: multipleTimersView!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if state != .initial {
            if player != nil {
                player.stop()
            }
            pause()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    fileprivate func addConstraints(to timerView: UIView) {
        let margins = containerView.layoutMarginsGuide
        timerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        timerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        timerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        timerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    fileprivate func showHolder(for feeling: Feeling) {
        holderHandler = HolderViewHandler(superView: view, delegate: self, feeling: feeling)
        holderHandler!.start()
    }
    
    @objc func appWillResingActive() {
        pause()
    }
    
    fileprivate func pause() {
        state = .pause
        timer.invalidate()
    }
    
    @objc func singleDurationButtonAction() {
        selectDuration(for: exercise.feelings.first!)
    }
    
    fileprivate func selectDuration(for feeling: Feeling) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DurationPickerViewController") as! DurationPickerViewController
        vc.delegate = self
        vc.feeling = feeling
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        if state == .playing {
            pause()
        } else if state == .pause || state == .initial {
            if currentFeelingNumber == nil {
                let feelingNumber = currentFeelingNumber ?? 0
                currentDuration = exercise.feelings[feelingNumber].duration
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
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
                player.delegate = self
                player.play()
            }

            if currentDuration == -1 {
                if currentFeelingNumber! < exercise.feelings.count - 1 {
                    self.showHolder(for: exercise.feelings[currentFeelingNumber! + 1])
                    timer.invalidate()
                } else {
                    timer.invalidate()
                    state = .done
                }
            } else {
                updateCurrentLabel()
            }
        }
    }
    
    fileprivate func updateCurrentLabel() {
        if isSingleTimer {
            singleTimerView!.label.text = "\(stringDuration(from: currentDuration!))"
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

extension ExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.feelings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feeling = exercise.feelings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelingTimerCell") as! FeelingTimerCell
        cell.durationButton.tag = indexPath.row
        cell.label.text = feeling.descriptionName
        cell.delegate = self
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
        
        if state == .playing && indexPath.row == currentFeelingNumber {
            cell.spinner.isHidden = false
            cell.spinner.startAnimating()
        } else {
            cell.spinner.isHidden = true
            cell.spinner.stopAnimating()
        }
        cell.updateConstaint(isInitialState: state == .initial)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        exercise.feelings.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
}

extension ExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension ExerciseViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if state == .done {
            delegate.didFinishExercise()
        }
    }
    
}

extension ExerciseViewController: DurationPickerViewControllerDelegate {
    func didSelect(duration: Int, for feeling: Feeling) {
        feeling.duration = duration
        currentDuration = duration
        if isSingleTimer {
            singleTimerView?.durationButton.setTitle("\(feeling.durationString) min", for: .normal)
        } else {
            let rowNumber = exercise.feelings.index(where: {$0.name == feeling.name})!
            multipleTimersView?.tableView.beginUpdates()
            multipleTimersView?.tableView.reloadRows(at: [IndexPath(row: rowNumber, section: 0)], with: .automatic)
            multipleTimersView?.tableView.endUpdates()
        }
    }
}

extension ExerciseViewController: FeelingTimerCellDelegate {
    
    func selectDuration(for cell: UITableViewCell) {
        let indexPath = multipleTimersView!.tableView.indexPathForRow(at: cell.center)!
        selectDuration(for: exercise.feelings[indexPath.row])
    }
    
}

extension ExerciseViewController: HolderViewHandlerDelegate {
    
    func holderDidFinish() {
        currentFeelingNumber! += 1
        currentDuration = exercise.feelings[currentFeelingNumber!].duration
        multipleTimersView?.tableView.reloadRows(at: [IndexPath(row: currentFeelingNumber! - 1, section: 0)], with: .automatic)
        updateCurrentLabel()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
}
