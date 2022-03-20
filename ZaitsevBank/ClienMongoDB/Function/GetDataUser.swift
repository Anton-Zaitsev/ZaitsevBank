//
//  GetDataUser.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.10.2021.
//

import Foundation
import RealmSwift

public class GetDataUser {
        
    public func get () async -> clientZaitsevBank? {
        
        let user: User = RealmSettings.getUser()
        let partitionKey = RealmSettings.getAuthIDClient()
        let configuration = user.configuration(partitionValue: partitionKey)
        
        do {
            let realm = try await Realm(configuration: configuration)
            if let data = realm.objects(clientZaitsevBank.self).filter("userID == '\(user.id)'").first {
                return data
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
               
    }
    
    public func getFromUser (_ userFromSign: User) async -> clientZaitsevBank? {
        
        let partitionKey = RealmSettings.getAuthIDClient()
        let configuration = userFromSign.configuration(partitionValue: partitionKey)
        
        do {
            let realm = try await Realm(configuration: configuration)
            
            if let data = realm.objects(clientZaitsevBank.self).filter("userID == '\(userFromSign.id)'").first {
                return data
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }

    }
}
