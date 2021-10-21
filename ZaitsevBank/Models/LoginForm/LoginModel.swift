//
//  LoginModel.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 04.10.2021.
//

import Foundation
import RealmSwift

public class LoginModel {
    
    public var Login : String = ""
    public var Password : String = ""
    
    public var Name : String = ""
    public var Family: String = ""
    public var FamilyName: String = ""
    
    public var Phone : String = ""
    public var Year : String = ""
    public var Pol : String = ""
    
    public func SafePasswordFromAutoLogin(Password: String) {
      //  let shaPass = Password.sha256()
        
    }
}
