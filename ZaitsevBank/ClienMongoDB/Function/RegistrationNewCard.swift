//
//  RegistrationNewCard.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import Foundation
import RealmSwift

class RegistrationNewCard {
    
    private let user: User = RealmSettings.getUser()
    
    public func newCard (typeCard : String, nameCard: String, data: String, numberCard: String, typeMoney: String, CVV: String) async -> Bool {
        
        let partitionKey = RealmSettings.getCardPartition()
        
        let configuration = user.configuration(partitionValue: partitionKey)
        
        do {
            let realm = try await Realm(configuration: configuration)
            
           
            if let dataCard = await GetCardUser().get(NoneUser: user) {
                           
                try realm.write {
                    var dataCardNew : clientCardsCredits = clientCardsCredits()
                    dataCardNew = dataCard
                    
                    
                    let cardRealm = clientCardsCredits_card()
                    cardRealm.nameCard = nameCard
                    cardRealm.typeCard = typeCard
                    cardRealm.data = data
                    cardRealm.numberCard = numberCard
                    cardRealm.typeMoney = typeMoney
                    cardRealm.cvvv = CVV
                    cardRealm.moneyCount.value = 0.0
                    
                    dataCardNew.card.append(cardRealm)
                    realm.add(dataCardNew, update: .modified)
                }
                return true
            }
            else {
                let userId: String = user.id.sha256()
                
                try realm.write {
                    let dataCardNew : clientCardsCredits = clientCardsCredits()
                    dataCardNew.authID = RealmSettings.getCardPartition()
                    dataCardNew.userID = userId
                    
                    let cardRealm = clientCardsCredits_card()
                    cardRealm.nameCard = nameCard
                    cardRealm.typeCard = typeCard
                    cardRealm.data = data
                    cardRealm.numberCard = numberCard
                    cardRealm.typeMoney = typeMoney
                    cardRealm.cvvv = CVV
                    cardRealm.moneyCount.value = 0.0
                    
                    dataCardNew.card.append(cardRealm)
                    realm.add(dataCardNew)
                }
                return true
            }
        }
        catch {
            return false
        }
    }
}
