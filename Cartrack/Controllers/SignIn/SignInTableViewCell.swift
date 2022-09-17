//
//  SignInTableViewCell.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import UIKit

protocol SignInTableCellDelegate {
    func signInTableCell(_ cell: SignInTableViewCell, didChangeText text: String) -> Void
    func signInTableCell(_ cell: SignInTableViewCell, didReturn textField: UITextField) -> Void
    func userDidSelectDropdownView() -> Void
}

class SignInTableViewCell: UITableViewCell {    
    static let identifier = "SignInTableViewCell"
    
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    private(set) var activeTextField:UITextField?
    var delegate: SignInTableCellDelegate?
    
    private lazy var secureTextToggleButton: UIView = {
        let secureTextView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setImage(UIImage(named: "show"), for: .normal)
        button.setImage(UIImage(named: "hide"), for: .selected)
        button.addTarget(self, action: #selector(self.toggleSecureText(sender:)), for: .touchUpInside)
        secureTextView.addSubview(button)
        button.center = secureTextView.center
        return secureTextView
    }()

    private lazy var dropDownButton: UIView = {
        let dropdownView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setImage(UIImage(named: "downArrow"), for: .normal)
        button.addTarget(self, action: #selector(self.dropdownAction(sender:)), for: .touchUpInside)
        dropdownView.addSubview(button)
        button.center = dropdownView.center
        return dropdownView
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLable.font = UIFont(name: "Helvetica", size: 14)
        textField.font = UIFont(name: "Helvetica", size: 16)
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCell(info: CellInfo) -> Void {
        textField.rightViewMode = .never
        textField.rightView = nil
        titleLable.text = info.title
        textField.isSecureTextEntry = info.isSecure
        textField.keyboardType = info.keyboardType
        textField.placeholder = info.placeholder
        textField.text = info.value
        
        if(info.isSecure) {
            textField.rightViewMode = .whileEditing
            textField.rightView = self.secureTextToggleButton
        }
        
        if(info.isDropdown) {
            textField.rightViewMode = .always
            textField.rightView = self.dropDownButton
        }
    }
    
    @objc
    func toggleSecureText(sender: UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        self.textField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc
    func dropdownAction(sender: UIButton) -> Void {
        self.delegate?.userDidSelectDropdownView()
    }

}

extension SignInTableViewCell {
   
    struct CellInfo {
        let title: String
        var value: String
        let placeholder: String
        let keyboardType: UIKeyboardType
        let isSecure: Bool
        let isDropdown: Bool
    }
}

extension SignInTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField?.resignFirstResponder()
        self.activeTextField = textField
        if(textField.rightViewMode == .always) {
            self.delegate?.userDidSelectDropdownView()
        }
        return (textField.rightViewMode != .always)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        let currentText: NSString = NSString(string: text)
        let finalString = currentText.replacingCharacters(in: range, with: string).trimWhiteSpaces()
        self.delegate?.signInTableCell(self, didChangeText: finalString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.activeTextField = nil
        self.delegate?.signInTableCell(self, didReturn: textField)
        return true
    }
    
}
