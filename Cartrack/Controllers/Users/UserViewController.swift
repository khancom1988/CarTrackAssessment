//
//  UserViewController.swift
//  Cartrack
//
//  Created by Aadil Majeed on 14/09/22.
//

import UIKit

class UserViewController: UIViewController {
    
    let coordinator: UserCoordinator
    let viewModel: UserViewModel
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    
    init(coordinator: UserCoordinator, viewModel: UserViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: "UserViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        self.tableView?.addSubview(refreshControl)

        ProgressView.shared.loadOn(view: self.view, animated: true)
        
        self.viewModel.usersPublisher = { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.tableView.reloadData()
                break
            case .failure(let error):
                weakSelf.showAlert(message: """
                                            \(error.localizedDescription).
                                            Please try again later.
                                            """)
                break
            }
            ProgressView.shared.removeFrom(view: weakSelf.view, animated: true)
            self?.refreshControl.endRefreshing()
        }
        
        self.viewModel.fetchUsers()
    }
    
    private func registerCell() -> Void {
        self.tableView.register(UINib(nibName: UserTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: UserTableViewCell.identifier)
    }

    private func showAlert(message: String) -> Void {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshData(_ sender:AnyObject){
        self.refreshControl.beginRefreshing()
        self.viewModel.fetchUsers()
    }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.updateCell(user: self.viewModel.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.coordinator.showUserDetail(user: self.viewModel.users[indexPath.row])
    }
}

