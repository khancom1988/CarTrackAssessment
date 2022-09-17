//
//  SignInCoordinator.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import Foundation
import UIKit

class SignInCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
   
    var navigationController: UINavigationController
    
    var signInCompletion: (() -> Void)?
    
    deinit {
        print("SignInCoordinator deinit called")
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let user = DataStore.sharedStore.registeredAppUser()
        let viewModel = SignInViewModel(appUser: user)
        let vc = SignInViewController.init(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func moveToNextController() -> Void {
        signInCompletion?()
    }
    
    func showCountryView(countries: [Country], completionHandler: @escaping ((_ selectedCountry: Country) -> Void)) -> Void {
        let vm = CountryViewModel(countries: countries, handler: completionHandler)
        let vc = CountryViewController(viewModel: vm)
        navigationController.present(vc, animated: true)
    }
}
