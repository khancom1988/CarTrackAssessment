//
//  CountryViewModel.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import Foundation

class CountryViewModel {
    
    typealias SelectedCountryHandler = ((_ selectedCountry: Country) -> Void)
    
    private let countries: [Country]
    
    let handler: SelectedCountryHandler
    
    var reloadHandler: (() -> Void)?
    
    var countryList: [Country] {
        didSet {
            self.reloadHandler?()
        }
    }
    
    init(countries: [Country], handler: @escaping SelectedCountryHandler) {
        self.countries = countries
        self.handler = handler
        self.countryList = countries
    }
    
    func search(searchText: String) -> Void {
        if searchText.isEmpty {
            self.countryList = self.countries
        }
        else{
            self.countryList = self.countries.filter({$0.nicename.caseInsensitiveContain(searchText) || $0.name.caseInsensitiveContain(searchText)})
        }
    }
}
