//
//  AppDelegate.swift
//  Cartrack
//
//  Created by Aadil Majeed on 14/09/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.signInCompletion = { [weak self] in
            self?.signInCompleted()
        }
        signInCoordinator.start()
        self.coordinator = signInCoordinator
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func signInCompleted() -> Void {
        self.coordinator?.removeAllChildCoordinators()
        window?.rootViewController = nil
        self.coordinator = nil
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let userCoordinator = UserCoordinator(navigationController: navigationController)
        userCoordinator.start()
        self.coordinator = userCoordinator
    }
}

