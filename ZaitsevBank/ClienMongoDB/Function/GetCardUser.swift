//
//  GetCardUser.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 30.10.2021.
//

import Foundation
import RealmSwift

public class GetCardUser {
    
    private var user: User = RealmSettings.getUser()
    
    public func get (NoneUser: User? = nil) async -> clientCardsCredits? {
        
        if let noneUser = NoneUser {
            user = noneUser
        }
        let partitionKey = RealmSettings.getCardPartition()
        let configuration = user.configuration(partitionValue: partitionKey)
        
        let userId: String = user.id.sha256()
        
        do {
            
            let realm = try await Realm(configuration: configuration)
            
            guard let data = realm.objects(clientCardsCredits.self).filter("userID == '\(userId)' ").first else {
                return nil}
            
            return data
            
        }
        catch{
            return nil
        }
    }
    
    public func getCards (NoneUser: User? = nil) async ->  [Cards] {
        if let noneUser = NoneUser {
            user = noneUser
        }
        var cardsClient : [Cards] = [Cards] ()
        guard let data = await get(NoneUser: NoneUser) else { return cardsClient}
        
        for client in data.card {
            var moneyCount: String = ""
            
            if (!electonValute(valute: client.typeMoney!)){
                
                if (floor(client.moneyCount.value!) == client.moneyCount.value!) { // Если число можно преобразовать в int
                    if let converted = Int(exactly: (client.moneyCount.value?.rounded())!) {
                        moneyCount = String(converted)
                        
                    } else {
                        moneyCount = String(format: "%.2f", client.moneyCount.value!)
                    }
                }
                else {
                    moneyCount = String(format: "%.2f", client.moneyCount.value!)
                }
                
            }
            else{
                moneyCount = String(client.moneyCount.value!)
            }
            
            var numberCard = client.numberCard!
            let index = numberCard.index(numberCard.endIndex, offsetBy: -4)
            numberCard = String(numberCard.suffix(from: index))
            numberCard = "•• \(numberCard)"
            
            cardsClient.append(Cards(typeImageCard: client.typeCard!, nameCard: client.nameCard!, numberCard: numberCard, moneyCount: moneyCount, typeMoney: client.typeMoney!))
        }
        return cardsClient
        
    }
    
    
    fileprivate func electonValute(valute: String) -> Bool {
        switch valute{
        case "₽" : return false
        case "$" : return false
        case "€" : return false
        case "Ƀ" : return true
        case "◊" : return true
        default:
            return false
        }
    }
}

