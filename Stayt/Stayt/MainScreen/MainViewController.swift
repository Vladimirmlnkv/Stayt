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
        
        let ex1 = Exercise(name: "Relaxed", description: "Get comfortable, sit with the straight back and close your eyes. Focus on your breath. Don't force it in any way, just become aware of it. You'll find yourself wondering, the moment you realise it just bring the attention back to the breath.", descriptionName: "Meditation", feelings: [Feeling(name: "Relaxed", descriptionName: "meditation")])
        let ex2 = Exercise(name: "Energized", description: "The goal of this exercise is to fill your body with oxygen. Get comfortable. It's completly normal if you feel dizzy during exercise. Don't try to force yourself in part where you have to stop breathing. Just let go any effort with exhalation and listen to your body.", descriptionName: "Breathwork", feelings: [Feeling(name: "Energized", descriptionName: "breathwork")])
        let ex3 = Exercise(name: "Motivated", description: "Get comfortable, sit with the straight back, closed eyes and hold your arms pointing in in different directions so you won't be able to see them with your lateral vision. If you feel the pain in your arms - it's absolutely normal, everyone do. Just observe it, don't try to avoid it in any way.", descriptionName: "Arm holding", feelings: [Feeling(name: "Motivated", descriptionName: "arm holding")])
        let ex4 = Exercise(name: "Blissed", description: "This is a powerfull combination of 3 different state changers. Complete them in any order you like. Feel yourself what word 'blissed' really means.", descriptionName: "Blessing", feelings: [Feeling(name: "Relaxed", descriptionName: "Meditation"),
                                                                             Feeling(name: "Energized", descriptionName: "Breathwork"),
                                                                             Feeling(name: "Motivated", descriptionName: "Arm holding")])
        exercises = [ex1, ex2, ex3, ex4]
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
