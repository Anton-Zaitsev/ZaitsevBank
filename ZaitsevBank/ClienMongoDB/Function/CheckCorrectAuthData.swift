//
//  CheckCorrectAuthData.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 05.10.2021.
//

import Foundation

public class CheckCorrectAuthData {
    
    public static func checkLogin(login: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: login)
    }
    
    public static func checkPassword(pass: String) -> Bool {
        return (pass.count >= 6)
    }
    
    public static func checkAuth(login: String, pass: String) -> Bool {
        return checkLogin(login: login) && checkPassword(pass: pass)
    }
    
    public static func formattedPhone(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XX-XX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
