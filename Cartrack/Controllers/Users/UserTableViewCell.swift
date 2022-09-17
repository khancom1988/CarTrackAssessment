//
//  UserTableViewCell.swift
//  Cartrack
//
//  Created by Aadil Majeed on 17/09/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCell(user: User) -> Void {
        nameLabel.text = user.name
        emailLabel.text = user.email
        addressLabel.text = user.address.formattedAddressLine
    }
}
