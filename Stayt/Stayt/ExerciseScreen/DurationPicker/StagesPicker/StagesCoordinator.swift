//
//  StagesCoordinator.swift
//  Stayt
//
//  Created by Владимир Мельников on 28/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol StagesCoordinatorDelegate: class {
    func stagesCoordinatorDidFinish()
}

class StagesCoordinator {
    
    static let coordinatorKey = "StagesCoordinator"
    
    fileprivate let storyboard = UIStoryboard(name: "Main", bundle: nil)
    fileprivate let activity: Activity
    fileprivate let presentingVC: UIViewController
    fileprivate weak var delegate: StagesCoordinatorDelegate?
    fileprivate var stagesVC: StagesDurationViewController!
    fileprivate var menuHandler: DurationsOptionsMenuHandler?
    
    init(activity: Activity, presentingVC: UIViewController, delegate: StagesCoordinatorDelegate) {
        self.activity = activity
        self.presentingVC = presentingVC
        self.delegate = delegate
    }
    
    func start() {
        stagesVC = storyboard.instantiateViewController(withIdentifier: "StagesDurationViewController") as! StagesDurationViewController
        stagesVC.stages = Array(activity.stages)
        stagesVC.exerciseName = activity.descriptionName
        stagesVC.delegate = self
        let navC = UINavigationController(rootViewController: stagesVC)
        presentingVC.present(navC, animated: true, completion: nil)
    }
    
}

extension StagesCoordinator: StagesDurationViewControllerDelegate {
    
    func didSelect(stage: ActivityStage) {
        
        let title = "\(stage.name!) stage duration"
        let completion = { (duration: Int) in
            try! mainRealm.write {
                stage.duration = duration
                self.activity.duration = self.activity.stages.reduce(into: 0) { $0 += $1.duration}
            }
            self.stagesVC.tableView.reloadData()
        }
        
        if !stage.avaliableDurations.isEmpty && stage.avaliableDurations.count <= 4 {
            menuHandler = DurationsOptionsMenuHandler(superView: stagesVC.navigationController!.view, title: title, durations: Array(stage.avaliableDurations))
            menuHandler!.currentDuration = stage.duration
            menuHandler!.completion = completion
            menuHandler!.showMenu()
        } else {
            let durationPicker = storyboard.instantiateViewController(withIdentifier: "DurationPickerViewController") as! DurationPickerViewController
            durationPicker.durations = Array(stage.avaliableDurations)
            durationPicker.labelTitle = title
            durationPicker.currentDuration = stage.duration
            durationPicker.completion = { (duration: Int) in
                completion(duration)
                self.stagesVC.dismiss(animated: true, completion: nil)
            }
            stagesVC.present(durationPicker, animated: true, completion: nil)
        }
    }
    
    func didPressDoneButton() {
        delegate?.stagesCoordinatorDidFinish()
    }
}
