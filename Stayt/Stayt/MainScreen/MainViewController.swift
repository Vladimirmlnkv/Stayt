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
    fileprivate let exerciseDataSource = ExerciseDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "small_question-mark"), style: .done, target: self, action: #selector(aboutAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CP", style: .done, target: self, action: #selector(currentPackScreenAction))
        exercises = exerciseDataSource.getExercises()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func currentPackScreenAction() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CurrentPackViewController") as! CurrentPackViewController
        vc.exercisePack = exerciseDataSource.getBeginnerPack()
        navigationController?.pushViewController(vc, animated: true)
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
