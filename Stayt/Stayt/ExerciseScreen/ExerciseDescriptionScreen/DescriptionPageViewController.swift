//
//  DescriptionPageViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 02/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol DescriptionPageViewControllerDelegate: class {
    func didPressStart()
}

class DescriptionPageViewController: UIPageViewController {
    
    var exerciseTitle: String!
    var exerciseDescription: String!
    var shouldShowStartButton = false
    weak var pageDelegate: DescriptionPageViewControllerDelegate?
    
    fileprivate lazy var pageViewControllers: [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = sb.instantiateViewController(withIdentifier: "ExerciseDescriptionViewController") as! ExerciseDescriptionViewController
        firstVC.exerciseTitle = exerciseTitle
        firstVC.exerciseDescription = exerciseDescription
        let secondVC = sb.instantiateViewController(withIdentifier: "VideoDescriptionViewController") as! VideoDescriptionViewController
        secondVC.shouldShowStartButton = shouldShowStartButton
        secondVC.delegate = self
        
        return [firstVC, secondVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = pageViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension DescriptionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard pageViewControllers.count > previousIndex else { return nil }
        return pageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex != pageViewControllers.count else { return nil }
        guard pageViewControllers.count > nextIndex  else { return nil }
        return pageViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension DescriptionPageViewController: VideoDescriptionViewControllerDelegate {
    
    func didPressStartButton() {
        pageDelegate?.didPressStart()
    }
    
    func didPressVideoButton() {
        
    }
}
