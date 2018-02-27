//
//  MainViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 16/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate var exercises: [Exercise]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "question-mark"), style: .done, target: self, action: #selector(aboutAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.white
        let ex1 = Exercise(name: ExerciseDescription.meditationFeelingName, description: ExerciseDescription.meditationDescription, descriptionName: ExerciseDescription.meditationName, isGuided: false, activities: [Activity(name: "Relaxed", descriptionName: "meditation")])
        let ex2 = Exercise(name: ExerciseDescription.breathWorkFeelingName, description: ExerciseDescription.breathWorkDescription, descriptionName: ExerciseDescription.breathWorkName, isGuided: false, activities: [Activity(name: "Energized", descriptionName: "breathwork")])
        let ex3 = Exercise(name: ExerciseDescription.armHoldFeelingName, description: ExerciseDescription.armHoldDescription, descriptionName: ExerciseDescription.armHoldName, isGuided: false, activities: [Activity(name: "Motivated", descriptionName: "arm holding")])
        let ex4 = Exercise(name: ExerciseDescription.blessingFeelingName, description: ExerciseDescription.blessingDescription, descriptionName: ExerciseDescription.blessingName, isGuided: false, activities: [Activity(name: "Relaxed", descriptionName: "Meditation"),
                                                                                                                                                                                                               Activity(name: "Energized", descriptionName: "Breathwork"),
                                                                                                                                                                                                               Activity(name: "Motivated", descriptionName: "Arm holding")])
        exercises = [ex1, ex2, ex3, ex4]
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func aboutAction() {
        let aboutVC = storyboard!.instantiateViewController(withIdentifier: "AboutViewController")
        present(aboutVC, animated: true, completion: nil)
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        let height = collectionView.frame.height / 4 - 20
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let coordinator = ExerciseCoodinator(exercise: exercises[indexPath.row], presentingVC: self)
        coordinator.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exercise = exercises[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeelingCell", for: indexPath) as! FeelingCell
        cell.label.text = exercise.name
        return cell
    }
    
}
