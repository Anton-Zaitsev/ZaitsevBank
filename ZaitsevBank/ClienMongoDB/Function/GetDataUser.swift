//
//  GetDataUser.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.10.2021.
//

import Foundation
import RealmSwift

public class GetDataUser {
    
    private var user: User = RealmSettings.getUser()
    
    public func get (NoneUser: User? = nil) async -> clientZaitsevBank? {

        if let noneUser = NoneUser {
            user = noneUser
        }
        let partitionKey = RealmSettings.getAuthIDClient()
        let configuration = user.configuration(partitionValue: partitionKey)
        
        let userId: String = user.id.sha256()
        
        do {
            let realm = try await Realm(configuration: configuration)
            
            if let data = realm.objects(clientZaitsevBank.self).filter("userID == '\(userId)' ").first {
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
