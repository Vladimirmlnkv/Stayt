//
//  OnboardingPageViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 30/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol OnboardingPageViewControllerDelegate {
    func startBeginnerPack()
}

class OnboardingPageViewController: UIPageViewController {
    
    var onboardingDelegate: OnboardingPageViewControllerDelegate!
    
    fileprivate lazy var onboardingViewControllers: [UIViewController] = {
        let sb = UIStoryboard(name: "Onboarding", bundle: nil)
        
        let firstVC = sb.instantiateViewController(withIdentifier: "IconedOnboardingViewController")
        
        let secondVC = sb.instantiateViewController(withIdentifier: "TextOnboardingViewController") as! TextOnboardingViewController
        secondVC.text = "Master meditation, breathwork and arm holding.\nEach exercise teaches you to better understand your mind and your body, while also makes you feel great"
        
        let thirdVC = sb.instantiateViewController(withIdentifier: "TextOnboardingViewController") as! TextOnboardingViewController
        thirdVC.text = "Use built-in diary to keep track of your progress and write down yout thought and ideas after doing exercises"
        let finalVC = sb.instantiateViewController(withIdentifier: "FinalOnboardingViewController") as! FinalOnboardingViewController
        finalVC.delegate = self
        
        return [firstVC, secondVC, thirdVC, finalVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = onboardingViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard onboardingViewControllers.count > previousIndex else { return nil }
        return onboardingViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex != onboardingViewControllers.count else { return nil }
        guard onboardingViewControllers.count > nextIndex  else { return nil }
        return onboardingViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension OnboardingPageViewController: FinalOnboardingViewControllerDelegate {
    
    func didPressStart() {
        onboardingDelegate.startBeginnerPack()
    }
    
}
