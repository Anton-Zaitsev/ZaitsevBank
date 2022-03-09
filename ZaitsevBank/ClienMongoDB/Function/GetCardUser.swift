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
    
    public func get () async -> clientCardsCredit? {
        
        if let currentData = await MongoBankFunctionMore.getNowData() {
            
            let partitionKey = RealmSettings.getCardPartition()
            let configuration = user.configuration(partitionValue: partitionKey)
                    
            do {
                
                let realm = try await Realm(configuration: configuration)
                
                guard let data = realm.objects(clientCardsCredit.self).first else {return nil}
                
                let emptyCard = data.card.where {
                    $0.data < currentData && $0.closed == false
                }.isEmpty // Находим, есть ли просроченные карты
                
                if(emptyCard == false) {
                     
                    try realm.write {
                        
                        for (index, card) in data.card.enumerated(){
                            if card.data! < currentData && card.closed == false {
                                data.card[index].closed = true
                            }
                        } // Если есть, сообщаем о просрочке карты
                        
                        realm.add(data, update: .modified)
                    }
                }
                
                return data
                
            }
            catch{
                return nil
            }
            
        }
        else {
            return nil
        }
    }
    
    public func getCards () async ->  [Cards] {

        var cardsClient : [Cards] = [Cards] ()
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale(identifier: "fr_FR")
        
        guard let data = await get() else { return cardsClient}
        
        for client in data.card {
            var moneyCount: String = ""
            
            let valuteTypeBank = ValuteZaitsevBank.init(rawValue: client.typeMoneyExtended!)!
            
            if (valuteTypeBank.electronValute){
                
                if (floor(client.moneyCount!) == client.moneyCount!) { // Если число можно преобразовать в double
                    if let converted = Int(exactly: (client.moneyCount?.rounded())!) {
                        moneyCount = fmt.string(for:converted)!
                        
                    } else {
                        moneyCount = fmt.string(for: client.moneyCount)!
                    }
                }
                else {
                    moneyCount = fmt.string(for: client.moneyCount)!
                }
                
            }
            else{
                moneyCount = fmt.string(for: client.moneyCount)!.replacingOccurrences(of: ".", with: ",")
            }
            
            var numberCard = client.numberCard!
            let index = numberCard.index(numberCard.endIndex, offsetBy: -4)
            numberCard = String(numberCard.suffix(from: index))
            numberCard = "•• \(numberCard)"
                        
            cardsClient.append(Cards(typeImageCard: client.typeCard!, typeMoney: valuteTypeBank.description, nameCard: client.nameCard!, numberCard: numberCard, moneyCount: moneyCount, cvv: client.cvvv!, data: client.data!, cardOperator: client.cardOperator!, typeMoneyExtended: client.typeMoneyExtended!, fullNumberCard: client.numberCard!, transactionID: client.transactionID!, closed: client.closed!))
            
        }
        return cardsClient
        
    }
    
    
    public func getCardsFromBuySale (valute: String, buySale: Bool) async ->  [Cards] {
        
        let valuteBank = ValuteZaitsevBank(rawValue: valute)?.description
        
        let data = await getCards()
        
        var sortData = [Cards]()
        
        for card in data {
            
            if (buySale){ // BUY
                if (card.typeMoney != valuteBank) {
                    sortData.append(card)
                }
            }
            else { // SALE
                if (card.typeMoney == valuteBank) {
                    sortData.append(card)
                }
            }
        }
        return sortData
        
    }
    
}


