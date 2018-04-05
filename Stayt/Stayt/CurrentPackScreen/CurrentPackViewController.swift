//
//  CurrentPackViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol CurrentPackViewControllerDelegate {
    func start(exercisePack: ExercisePack, presentingVC: UIViewController)
}

class CurrentPackViewController: UIViewController {

    @IBOutlet var packNameLabel: UILabel!
    @IBOutlet var currentExerciseLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var exercisePack: ExercisePack!
    var delegate: CurrentPackViewControllerDelegate!
    
    fileprivate var completedPackView: CompletedPackView?
    var exerciseDataSource: ExerciseDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Main", style: .done, target: self, action: #selector(testScreenAction))
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "small_question-mark"), style: .done, target: self, action: #selector(aboutAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.white
        
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        startButton.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exercisePack = exerciseDataSource.getBeginnerPack()
        if exercisePack.isCompleted {
            if completedPackView == nil {
                completedPackView = CompletedPackView(frame: view.frame)
                completedPackView!.delegate = self
                view.addSubview(completedPackView!)
                NSLayoutConstraint.activate([
                    completedPackView!.topAnchor.constraint(equalTo: view.topAnchor),
                    completedPackView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    completedPackView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    completedPackView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
            }
        } else {
            setupUI()
        }
    }
    
    @objc func testScreenAction() {
        let mainVC = storyboard!.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        navigationController?.pushViewController(mainVC, animated: true)
        
    }
    
    @objc func aboutAction() {
        let aboutVC = storyboard!.instantiateViewController(withIdentifier: "AboutViewController")
        present(aboutVC, animated: true, completion: nil)
    }
    
    fileprivate func setupUI() {
        packNameLabel.text = exercisePack.name
        currentExerciseLabel.text = exercisePack.exercises[exercisePack.currentExerciseNumber].descriptionName
        dayLabel.text = "Level \(exercisePack.currentExerciseNumber + 1) of \(exercisePack.exercises.count)"
    }

    @IBAction func startButtonAction(_ sender: Any) {
        delegate.start(exercisePack: exercisePack, presentingVC: self)
    }
    
    @IBAction func overviewButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PackOverviewViewController") as! PackOverviewViewController
        vc.exercisePack = exerciseDataSource.getBeginnerPack()
        present(vc, animated: true, completion: nil)
        
    }
}

extension CurrentPackViewController: CompletedPackViewDelegate {
    
    func startOver() {
        try! mainRealm.write {
            exercisePack.currentExerciseNumber = 0
            exercisePack.isCompleted = false
        }
        setupUI()
        completedPackView!.removeFromSuperview()
    }
    
}
