//
//  SettingApp.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 11.10.2021.
//

import Foundation

struct SettingApp {
    static let nameKeyFirstSettings = "isLogin"
}

extension UserDefaults{
    
    //MARK: Check Login
    func SetisLogin(_ settings: Bool) {
        self.set(settings, forKey: SettingApp.nameKeyFirstSettings)
    }
    
    func isLogin() -> Bool {
        return bool(forKey: SettingApp.nameKeyFirstSettings)
    }
    
    
}
