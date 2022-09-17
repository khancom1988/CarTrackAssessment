//
//  Coordinator.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set}
    var navigationController: UINavigationController { get set}
    func start()
}

extension Coordinator {
    
    mutating func removeAllChildCoordinators() -> Void {
        self.navigationController.viewControllers.removeAll()
        self.childCoordinators.removeAll()
    }
    
    func popViewController(animation: Bool) -> Void {
        self.navigationController.popViewController(animated: animation)
    }
    
    func popToRootViewController(animation: Bool) -> Void {
        self.navigationController.popToRootViewController(animated: animation)
    }

    func dismissController(animation: Bool, completion:(() -> Void)? = nil) -> Void {
        self.navigationController.dismiss(animated: animation, completion: completion)
    }
}
