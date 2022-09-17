//
//  SignInViewController.swift
//  Cartrack
//
//  Created by Aadil Majeed on 14/09/22.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        signInButton.frame = CGRect(x: 0, y: 0, width: 280, height: 40)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.tintColor = .white
        signInButton.backgroundColor = .blue
        signInButton.layer.cornerRadius = 10.0
        signInButton.addTarget(self, action: #selector(self.signInAction), for: .touchUpInside)
        return signInButton
    }()
    
    let viewModel: SignInViewModel
    let coordinator: SignInCoordinator
    
    deinit {
        print("SignInViewController deinit called")
    }
    
    init(coordinator: SignInCoordinator, viewModel: SignInViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: "SignInViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerCell()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.viewModel.validateSignInFieldHandler = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        self.viewModel.competionHandler = { [weak self] in
            self?.coordinator.moveToNextController()
        }
        
        self.viewModel.showProgressBar = { [weak self] show in
            guard let weakSelf = self else { return }
            if(show) {
                ProgressView.shared.loadOn(view: weakSelf.view, animated: true)
            }
            else {
                ProgressView.shared.removeFrom(view: weakSelf.view, animated: true)
            }
        }

    }
    
    private func registerCell() -> Void {
        self.tableView.register(UINib(nibName: SignInTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: SignInTableViewCell.identifier)
    }
    
    @objc
    func signInAction() -> Void {
        self.viewModel.login()
    }
    
    private func showAlert(message: String) -> Void {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SignInTableViewCell.identifier, for: indexPath) as! SignInTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.updateCell(info: self.viewModel.cellInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60.0))
        view.addSubview(self.signInButton)
        self.signInButton.center = view.center
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
}

extension SignInViewController: SignInTableCellDelegate {
    
    func signInTableCell(_ cell: SignInTableViewCell, didChangeText text: String) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.viewModel.updateValue(value: text, forIndex: indexPath.row)
        }
    }
    
    func signInTableCell(_ cell: SignInTableViewCell, didReturn textField: UITextField) {
        if let indexPath = tableView.indexPath(for: cell),
            let text = textField.text {
            self.viewModel.updateValue(value: text, forIndex: indexPath.row)
        }
    }
    
    func userDidSelectDropdownView() {
        self.coordinator.showCountryView(countries: self.viewModel.countries, completionHandler: { [weak self] country in
            if let index = self?.viewModel.cellInfo.firstIndex(where: {$0.title == SignInViewModel.CellType.country.rawValue}) {
                self?.viewModel.updateValue(value: country.nicename, forIndex: index)
                self?.tableView.reloadData()
            }
        })
    }
}
