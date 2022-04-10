//
//  SettingApp.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 11.10.2021.
//

import Foundation

struct SettingApp {
    static let userIDZaitsevBank = "userID"
    static let nameKeyFirstSettings = "isLogin"
    static let nameKeyUseFaceTouchID = "isFaceID"
    static let nameKeyNameScreensaver = "isNameScreensaver"
    static let APICoinCap = "51e9fe33-fffe-4a31-83b0-19a230a712b7"
}

extension UserDefaults{
    
    //MARK: Check Login
    func SetisLogin(_ settings: Bool) {
        self.set(settings, forKey: SettingApp.nameKeyFirstSettings)
    }
    
    func isLogin() -> Bool {
        return bool(forKey: SettingApp.nameKeyFirstSettings)
    }
    //MARK: Check Uses Fase or TouchID
    
    func SetisFaceTouchId(_ settings: Bool) {
        self.set(settings, forKey: SettingApp.nameKeyUseFaceTouchID)
    }
    
    func isUsesFaceTouchID() -> Bool {
        return bool(forKey: SettingApp.nameKeyUseFaceTouchID)
    }
    //MARK: Check NameScreensaver
    
    func checkNameScreensaver() -> Bool {
       return self.object(forKey: SettingApp.nameKeyNameScreensaver) != nil
    }
    func isNameScreensaver() -> String {
        return string(forKey: SettingApp.nameKeyNameScreensaver)!
    }
    func SetisNameScreensaver(_ settings: String) {
        self.set(settings, forKey: SettingApp.nameKeyNameScreensaver)
    }
    
    //MARK: Check userID
    
    func checkUserID() -> Bool {
       return self.object(forKey: SettingApp.userIDZaitsevBank) != nil
    }
    func isUserID() -> String {
       return string(forKey: SettingApp.userIDZaitsevBank)!

    }
    func SetisUserID(_ settings: String) {
        self.set(settings, forKey: SettingApp.userIDZaitsevBank)
    }
}
