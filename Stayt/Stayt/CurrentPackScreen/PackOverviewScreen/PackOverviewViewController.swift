//
//  PackOverviewViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 23/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class PackOverviewViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate var indexOfCellBeforeDragging = 0
    fileprivate var coordinator: ExerciseCoodinator?
    var exercisePack: ExercisePack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = exercisePack.name
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(row: exercisePack.currentExerciseNumber, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func indexOfMajorCell() -> Int {
        let itemWidth = cardWidth()
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    fileprivate func cardWidth() -> CGFloat {
        return collectionView.frame.width - 60 - 10*2
    }
}

extension PackOverviewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = cardWidth()
        let height = collectionView.frame.height - 20
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

extension PackOverviewViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercisePack.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exercise = exercisePack.exercises[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackOverviewCell", for: indexPath) as! PackOverviewCell
        
        cell.delegate = self
        cell.levelLabel.text = "Level \(indexPath.row + 1)"
        cell.exerciseLabel.text = exercise.descriptionName
        
        cell.startButton.layer.borderColor = Colors.mainActiveColor.cgColor
        
        if indexPath.row == exercisePack.currentExerciseNumber {
            cell.startButton.setTitle("Begin", for: .normal)
            cell.statusImageView.image = #imageLiteral(resourceName: "circle")
            cell.startButton.isEnabled = true
        } else if indexPath.row < exercisePack.currentExerciseNumber {
            cell.startButton.setTitle("Repeat", for: .normal)
            cell.statusImageView.image = #imageLiteral(resourceName: "checmark")
            cell.startButton.isEnabled = true
        } else {
            cell.startButton.setTitle("Locked", for: .normal)
            cell.statusImageView.image = #imageLiteral(resourceName: "locked-padlock")
            cell.startButton.isEnabled = false
            cell.startButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        cell.statusImageView.tintColor = Colors.mainActiveColor
        
        cell.layer.cornerRadius = 10
        cell.startButton.layer.borderWidth = 1.0
        cell.startButton.layer.cornerRadius = 10
        
        return cell
    }
    
}

extension PackOverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < exercisePack.exercises.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            
            let freeSpace = (60 + 10 * 2)
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = cardWidth() * CGFloat(snapToIndex) + 10 + CGFloat(snapToIndex) * 10 - CGFloat(freeSpace / 2)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension PackOverviewViewController: PackOverviewCellDelegate {
    
    func didPressStartButton(for cell: PackOverviewCell) {
        if let index = collectionView.indexPathForItem(at: cell.center) {
            coordinator = ExerciseCoodinator(exercise: exercisePack.exercises[index.row], presentingVC: self, exercisePack: exercisePack)
            coordinator!.start()
        }
    }
    
}
