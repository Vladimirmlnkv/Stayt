//
//  ExerciseSection.swift
//  Stayt
//
//  Created by Владимир Мельников on 19/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol ExerciseSectionDelegate: class {
    func didSelect(exercise: Exercise)
}

class ExerciseSection: NSObject {
    
    let name: String
    let exercises: [Exercise]
    
    let exerciseSectionView: ExerciseSectionView
    weak var delegate: ExerciseSectionDelegate?
    
    init(name: String, exercises: [Exercise], delegate: ExerciseSectionDelegate) {
        self.name = name
        self.exercises = exercises
        self.delegate = delegate
        exerciseSectionView = ExerciseSectionView(frame: CGRect())
        exerciseSectionView.sectionTitleLabel.text = name
        super.init()
        exerciseSectionView.collectionView.register( UINib(nibName: "ExerciseSectionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseSectionCollectionCell")
        exerciseSectionView.collectionView.dataSource = self
        exerciseSectionView.collectionView.delegate = self
    }
    
    func layout(on superView: UIView, topAnchor: NSLayoutYAxisAnchor) {
        superView.addSubview(exerciseSectionView)
        exerciseSectionView.translatesAutoresizingMaskIntoConstraints = false
        exerciseSectionView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        exerciseSectionView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
        exerciseSectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        exerciseSectionView.heightAnchor.constraint(equalToConstant: superView.frame.height / 4).isActive = true
        exerciseSectionView.collectionView.reloadData()
    }
}

extension ExerciseSection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseSectionCollectionCell", for: indexPath) as! ExerciseSectionCollectionCell
        cell.nameLabel.text = exercises[indexPath.row].descriptionName
        cell.middleLabel.text = String(exercises[indexPath.row].descriptionName.first!).capitalized
        return cell
    }
}

extension ExerciseSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(exercise: exercises[indexPath.row])
    }
}

extension ExerciseSection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
    }
    
}
