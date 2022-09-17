//
//  UserCoordinator.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import Foundation
import UIKit

class UserCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
   
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let userViewController = UserViewController(coordinator: self, viewModel: UserViewModel())
        userViewController.title = "Users"
        navigationController.pushViewController(userViewController, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.isNavigationBarHidden = false
    }

    func showUserDetail(user: User) -> Void {
        let vm = UserDetailViewModel(user: user)
        let vc = UserDetailViewController(coordinator: self, viewModel: vm)
        vc.title = "Detail"
        navigationController.pushViewController(vc, animated: true)
        vc.navigationItem.largeTitleDisplayMode = .never
    }
}
