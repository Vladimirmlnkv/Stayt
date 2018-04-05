//
//  MainCoordinator.swift
//  Stayt
//
//  Created by Владимир Мельников on 30/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    private let window: UIWindow
    private let shouldShowOnboardingKey = "shouldShowOnboarding"
    
    fileprivate let exerciseCoordinatorKey = "exerciseCoordinatorKey"
    fileprivate var coordinators = [String: Any]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let shouldShowOnboarding = UserDefaults.standard.value(forKey: shouldShowOnboardingKey) as? Bool
        
        if shouldShowOnboarding == nil || shouldShowOnboarding! {
            let sb = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVC = sb.instantiateInitialViewController() as! OnboardingPageViewController
            onboardingVC.onboardingDelegate = self
            window.rootViewController = onboardingVC
        } else {
            showMainScreen(animated: false)
        }
    
        window.makeKeyAndVisible()
    }
    
    private func showMainScreen(animated: Bool) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateInitialViewController() as! UITabBarController
        let firstNavVC = mainVC.viewControllers?.first! as! UINavigationController
        let currentPackVC = firstNavVC.viewControllers.first as! CurrentPackViewController
        currentPackVC.exerciseDataSource = ExerciseDataSource()
        currentPackVC.delegate = self
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.window.rootViewController = mainVC
            }, completion: nil)
        } else {
            window.rootViewController = mainVC
        }
    }
    
}

extension MainCoordinator: OnboardingPageViewControllerDelegate {
    
    func startBeginnerPack() {
        UserDefaults.standard.set(false, forKey: shouldShowOnboardingKey)
        showMainScreen(animated: true)
    }
    
}

extension MainCoordinator: CurrentPackViewControllerDelegate {
    
    func start(exercisePack: ExercisePack, presentingVC: UIViewController) {
        let coordinator = ExerciseCoodinator(exercise: exercisePack.exercises[exercisePack.currentExerciseNumber], presentingVC: presentingVC, exercisePack: exercisePack)
        coordinator.start()
        coordinator.coordinationDelegate = self
        coordinators[exerciseCoordinatorKey] = coordinator
    }
    
}

extension MainCoordinator: ExerciseCoodinatorCoordinationDelegate {
    
    func didFinish() {
        coordinators[exerciseCoordinatorKey] = nil
    }

}
