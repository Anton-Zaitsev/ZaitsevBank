//
//  RealmSettings.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.10.2021.
//

import Foundation
import RealmSwift
public class RealmSettings {
        
    public static func getApp() -> App {
        return App(id: "zaitsevbank-xhnim")
    }
    public static func getAuthIDClient() -> String {
       return "ClientZaitsevBankRequared".sha256()
    }
    public static func getUser() -> User {
        return getApp().currentUser!
    }
        
}
