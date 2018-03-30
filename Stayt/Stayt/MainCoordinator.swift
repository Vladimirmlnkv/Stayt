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
        let mainVC = sb.instantiateInitialViewController()
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
