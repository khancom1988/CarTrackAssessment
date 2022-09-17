//
//  UserDetailViewController.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import UIKit
import MapKit

class UserDetailViewController: UIViewController {

    @IBOutlet private var mapKit: MKMapView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var officeLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var websiteLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!

    private var region = MKCoordinateRegion()
    
    let coordinator: UserCoordinator
    let viewModel: UserDetailViewModel
    
    init(coordinator: UserCoordinator, viewModel: UserDetailViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: "UserDetailViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.nameLabel.text = self.viewModel.user.name
        self.officeLabel.text = self.viewModel.user.company.name
        self.phoneLabel.text = self.viewModel.user.phone
        self.emailLabel.text = self.viewModel.user.email
        self.websiteLabel.text = self.viewModel.user.website
        self.addressLabel.text = self.viewModel.user.address.formattedAddressLine
        
        self.setRegion(self.viewModel.coordinate)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapKit.region = self.region
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }

}
