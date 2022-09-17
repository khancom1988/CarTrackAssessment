//
//  SignInViewModel.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import Foundation

class AuthUser {
    var userName: String = ""
    var password: String = ""
    var country: String = ""
}

class SignInViewModel {
    let appUser: AppUser
    let authUser = AuthUser()
    let countries: [Country] = Cartrack.load("countries.json")

    private(set) var cellInfo: [SignInTableViewCell.CellInfo] = [
        SignInTableViewCell.CellInfo(title: CellType.userName.rawValue, value: "", placeholder: "Enter user name", keyboardType: .default, isSecure: false, isDropdown: false),
        SignInTableViewCell.CellInfo(title: CellType.password.rawValue, value: "", placeholder: "Enter password", keyboardType: .default, isSecure: true, isDropdown: false),
        SignInTableViewCell.CellInfo(title: CellType.country.rawValue, value: "", placeholder: "Select Country", keyboardType: .default, isSecure: false, isDropdown: true),
    ]
    
    var validateSignInFieldHandler: ((_ errorMessage: String) -> Void)?
   
    var competionHandler: (() -> Void)?
    
    var showProgressBar: ((Bool) -> Void)?


    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
    
    func updateValue(value: String, forIndex index: Int) -> Void {
        guard let type = SignInViewModel.CellType(rawValue: self.cellInfo[index].title) else { return }
        switch type {
        case .userName:
            self.authUser.userName = value
        case .password:
            self.authUser.password = value
        case .country:
            self.authUser.country = value
        }
        self.cellInfo.modifyElement(atIndex: index, {$0.value = value})
    }
    
    func login() -> Void {
        if self.isValidUser {
            self.showProgressBar?(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.showProgressBar?(false)
                self?.competionHandler?()
            }
        }
    }
    
    private var isValidUser: Bool {
        var retValue = false
        if self.appUser.userName == self.authUser.userName && self.appUser.password == self.authUser.password && self.appUser.country == self.authUser.country {
            retValue = true
        }
        else if (self.appUser.userName != self.authUser.userName || self.appUser.password != self.authUser.password) {
            self.validateSignInFieldHandler?("User Name or Password is incorrect")
            retValue = false
        }
        else {
            self.validateSignInFieldHandler?("Country doesnot match")
            retValue = false
        }
        return retValue
    }
}

extension SignInViewModel {
    enum CellType: String {
        case userName = "User Name"
        case password = "Password"
        case country = "Country"
    }
}
