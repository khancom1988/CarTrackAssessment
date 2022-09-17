//
//  UserViewModel.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import Foundation

protocol UserProtocol {
    var users: [User]  {get set}
    func fetchUsers() -> Void
}

class UserViewModel: UserProtocol {
    
    var users: [User] = []
   
    var usersPublisher: ((_ result: Result<[User], Error>) -> ())?

    func fetchUsers() {
        HttpClient.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.usersPublisher?(.success(users))
            case .failure(let error):
                self?.usersPublisher?(.failure(error))
            }
        }
    }
}
