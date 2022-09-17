//
//  Extensions.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import Foundation

extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension String {
    func trimWhiteSpaces()-> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var isValidUserName: Bool {
        if(self.containsInvalidUserNameChars) {
            return false
        }
        else if self.first?.isNumber == true{
            return false
        }
        return true
    }
    
    var isValidPassword: Bool {
        if(self.containsWhitespacesAndNewlines || self.containsWhitespaces) {
            return false
        }
        else if self.count < 6 {
            return false
        }
        return true
    }

    
    var containsInvalidUserNameChars: Bool {
        var containsSpecialChar = false
        let specialCaseChars = CharacterSet(charactersIn: "€£¥•.:;!@#$%^&*()-+={}?,<>[]/\\|~\'\"")
        if (self.rangeOfCharacter(from: specialCaseChars) != nil || self.containsWhitespacesAndNewlines || self.containsWhitespaces){
            containsSpecialChar = true
        }
        return containsSpecialChar
    }
    
    var containsWhitespacesAndNewlines: Bool {
        return self.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil
    }
    
    var containsWhitespaces: Bool {
        return self.rangeOfCharacter(from: CharacterSet.whitespaces) != nil
    }
    
    func caseInsensitiveContain(_ other: String) -> Bool {
        let uppercase = self.uppercased()
        let otherUppercase = other.uppercased()
        return uppercase.contains(otherUppercase)
    }
}

extension Array {
    mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> ()) {
        for index in indices {
            modifyElement(atIndex: index) { body(index, &$0) }
        }
    }

    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
    
    func filterDuplicate<T>(_ keyValue:(Element)->T) -> [Element] {
        var uniqueKeys = Set<String>()
        return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
    }
}
