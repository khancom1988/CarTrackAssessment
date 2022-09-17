//
//  CountryViewController.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import UIKit

class CountryViewController: UIViewController {
    let viewModel: CountryViewModel
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    init(viewModel: CountryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CountryViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        self.searchBar.isTranslucent = true
        self.searchBar.placeholder = "Search..."
        
        self.viewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }


    @IBAction func dismiss(_ sender: Any) -> Void {
        self.dismiss(animated: true)
    }
}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "country_cell_identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let country = self.viewModel.countryList[indexPath.row]
        cell?.imageView?.image = UIImage(named: country.iso.lowercased())
        cell?.textLabel?.text = country.nicename
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = self.viewModel.countryList[indexPath.row]
        self.dismiss(animated: true) { [weak self, country] in
            self?.viewModel.handler(country)
        }
    }
}

extension CountryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(searchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder()
    }
}
