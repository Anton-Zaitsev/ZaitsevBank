//
//  UserModel.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.04.2022.
//

import Foundation

public class UserModel : Codable {
    
    public var userID: String = ""

    public var login: String = ""

    public var password: String = ""
    public var firstName: String = ""

    public var lastName: String = ""
    public var middleName: String?
    public var birthday: String = ""

    public var gender: String = ""
    
    public var phone: String = ""
}
