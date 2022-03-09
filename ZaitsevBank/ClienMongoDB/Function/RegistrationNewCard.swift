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
    
    public func newCard (cardOperator: String, typeCard : String, nameCard: String, data: Date, numberCard: String, typeMoney: String, CVV: String) async -> Bool {
        
        let partitionKey = RealmSettings.getCardPartition()
        
        let configuration = user.configuration(partitionValue: partitionKey)
        
        do {
            let realm = try await Realm(configuration: configuration)
            
           
            if let dataCard = await GetCardUser().get() {
                           
                try realm.write {
                    var dataCardNew : clientCardsCredit = clientCardsCredit()
                    dataCardNew = dataCard
                     
                    let cardRealm = clientCardsCredit_card()
                    cardRealm.nameCard = nameCard
                    cardRealm.typeCard = typeCard
                    cardRealm.data = data
                    cardRealm.numberCard = numberCard
                    cardRealm.cvvv = CVV
                    cardRealm.moneyCount = 0.0
                    cardRealm.typeMoneyExtended = typeMoney
                    cardRealm.cardOperator = cardOperator
                    cardRealm.transactionID = CardGenerator().generateTransactionID(NumberCard: numberCard)
                    cardRealm.closed = false
                    
                    dataCardNew.card.append(cardRealm)
                    realm.add(dataCardNew, update: .modified)
                }
                return true
            }
            else {
                
                try realm.write {
                    let dataCardNew : clientCardsCredit = clientCardsCredit()
                    dataCardNew.authID = RealmSettings.getCardPartition()
                    
                    let cardRealm = clientCardsCredit_card()
                    cardRealm.nameCard = nameCard
                    cardRealm.typeCard = typeCard
                    cardRealm.data = data
                    cardRealm.numberCard = numberCard
                    cardRealm.cvvv = CVV
                    cardRealm.moneyCount = 0.0
                    cardRealm.typeMoneyExtended = typeMoney
                    cardRealm.cardOperator = cardOperator
                    cardRealm.transactionID = CardGenerator().generateTransactionID(NumberCard: numberCard)
                    cardRealm.closed = false
                    
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
