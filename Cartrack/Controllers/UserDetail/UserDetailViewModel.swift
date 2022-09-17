//
//  UserDetailViewModel.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import Foundation
import CoreLocation

class UserDetailViewModel {
   
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat = Double(self.user.address.geo.lat), let long = Double(self.user.address.geo.lng) else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
