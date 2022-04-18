//
//  CardsManager.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.04.2022.
//

import Foundation
import SwiftyJSON

public class CardsManager {
    
    private func decryptJSON(_ userID: String,data: Data) -> Data? {
        let key256 = userID.replacingOccurrences(of: "-", with: "").prefix(32) // 32 знака берем
        let iv = "ZaitsevBank_API_" // 16 bytes for IV
        let aes256 = AES(key: String(key256), iv: iv)
        
        let jsonData = aes256?.decrypt(data: data)
        
        return jsonData
    }
    
    private func convertedCardDB_CardZaitsevBank(_ card: CardModel) -> Cards?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        if let formattedData = dateFormatter.date(from: card.DataClosedCard) {
            
            let fmt = NumberFormatter()
            fmt.numberStyle = .decimal
            fmt.locale = Locale(identifier: "fr_FR")
            
            
            var moneyCount: String = ""
            let valuteTypeBank = ValuteZaitsevBank.init(rawValue: card.TypeMoney)!
            
            if (valuteTypeBank.electronValute){
                
                if (floor(card.MoneyCard) == card.MoneyCard) { // Если число можно преобразовать в double
                    if let converted = Int(exactly: (card.MoneyCard.rounded())) {
                        moneyCount = fmt.string(for:converted)!
                        
                    } else {
                        moneyCount = fmt.string(for: card.MoneyCard)!
                    }
                }
                else {
                    moneyCount = fmt.string(for: card.MoneyCard)!
                }
                
            }
            else{
                moneyCount = fmt.string(for: card.MoneyCard)!.replacingOccurrences(of: ".", with: ",")
            }
            
            var numberCard = card.NumberCard
            let index = numberCard.index(numberCard.endIndex, offsetBy: -4)
            numberCard = String(numberCard.suffix(from: index))
            numberCard = "•• \(numberCard)"
            
            let typeImageCard = card.CardOperator.searchLogoWalletCard()
                        
            return Cards(typeImageCard: typeImageCard, typeMoney: valuteTypeBank.description, nameCard: card.NameCard, numberCard: numberCard, moneyCount: moneyCount, cvv: card.CVV, data: formattedData, cardOperator: card.CardOperator, typeMoneyExtended: card.TypeMoney, fullNumberCard: card.NumberCard.formatCardNumber(), transactionID: card.TransactionCard, closed: card.ClosedCard)
            
        }
        else {
            return nil
        }
    }
    
    public var Error = "Не удалось выполнить запрос"
    
    public func GetAllCards() async -> [Cards] {
        var cards = [Cards]()
        if (UserDefaults.standard.checkUserID()) {
            let userID = UserDefaults.standard.isUserID()
            let request = ClienZaitsevBankAPI.getRequestGetAllCards(userID: userID)
            
            do {
                let (cardData,responce) = try await URLSession.shared.data(for: request)
                if let code = (responce as? HTTPURLResponse)?.statusCode {
                    
                    if let requestResult =  RequestResult.init(rawValue: code){
                        switch requestResult{
                        case .OK :
                            if let jsonData = decryptJSON(userID,data: cardData) {
                                
                                let arrayCards = try JSONDecoder().decode([CardModel].self, from: jsonData)
                                for card in arrayCards {
                                    if let convertedCard =  convertedCardDB_CardZaitsevBank(card) {
                                        cards.append(convertedCard)
                                    }
                                }
                                return cards
                            }
                            else {
                                return cards
                            }
                        case .NotFound:
                            Error = "Ваши карты не были найдены"
                            return cards
                        case .EthernalServer:
                            Error = "Сервер временно не доступен"
                            return cards
                        case .NotCreate:
                            Error = "Не удалось создать карту"
                            return cards
                        case .BadRequest:
                            Error = "Не удалось выполнить ваш запрос"
                            return cards
                        }
                    }
                    else { return cards}
                }
                else { return cards}
                
            }
            catch {
                return cards
            }
            
        }
        else {
            return cards
        }
    }
    
    public func CreateCard(CardOperator: String, NameCard: String, TypeMoney: String) async -> Bool{
        if (UserDefaults.standard.checkUserID()) {
            let userID = UserDefaults.standard.isUserID()
            let request = ClienZaitsevBankAPI.getRequestCreateCard(userID: userID, CardOperator: CardOperator, NameCard: NameCard, TypeMoney: TypeMoney)
            
            do {
                let (_,responce) = try await URLSession.shared.data(for: request)
                if let code = (responce as? HTTPURLResponse)?.statusCode {
                    
                    if let requestResult =  RequestResult.init(rawValue: code){
                        switch requestResult{
                        case .OK :
                            return true
                        case .NotFound:
                            Error = "Данные по карте не были найдены"
                            return false
                        case .EthernalServer:
                            Error = "Сервер временно не доступен"
                            return false
                        case .NotCreate:
                            Error = "Не удалось создать вашу карту"
                            return false
                        case .BadRequest:
                            Error = "Не удалось выполнить ваш запрос"
                            return false
                        }
                    }
                    else { return false}
                }
                else { return false}
                
            }
            catch {
                return false
            }
            
        }
        else {
            return false
        }
    }
    
    public func GetCardsBuySale(TypeValute: String, BuySale: Bool) async -> [Cards]{
        var cards = [Cards]()
        if (UserDefaults.standard.checkUserID()) {
            let userID = UserDefaults.standard.isUserID()
            let request = ClienZaitsevBankAPI.getRequestGetCardsBuySale(userID: userID, TypeValute: TypeValute, BuySale: BuySale)
            do {
                let (cardData,responce) = try await URLSession.shared.data(for: request)
                if let code = (responce as? HTTPURLResponse)?.statusCode {
                    
                    if let requestResult =  RequestResult.init(rawValue: code){
                        switch requestResult{
                        case .OK :
                            if let jsonData = decryptJSON(userID,data: cardData) {
                                
                                let arrayCards = try JSONDecoder().decode([CardModel].self, from: jsonData)
                                for card in arrayCards {
                                    if let convertedCard = convertedCardDB_CardZaitsevBank(card) {
                                        cards.append(convertedCard)
                                    }
                                }
                                return cards
                            }
                            else {
                                return cards
                            }
                        case .NotFound:
                            Error = "Ваши карты по выбранной валюты не были найдены"
                            return cards
                        case .EthernalServer:
                            Error = "Сервер временно не доступен"
                            return cards
                        case .NotCreate:
                            Error = "Не удалось создать карту"
                            return cards
                        case .BadRequest:
                            Error = "Не удалось выполнить ваш запрос"
                            return cards
                        }
                    }
                    else { return cards}
                }
                else { return cards}
                
            }
            catch {
                return cards
            }
        }
        else {
           return cards
        }
    }
    
    public func ConvertValute(ValuteA: String, ValuteB: String,BuySale: Bool,_ Count: Double? = nil) async -> (Double,Double,String)?{
        
        do {
            let (count,responce) = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestValuteAtoValuteB(ValuteA: ValuteA, ValuteB: ValuteB, BuySale: BuySale,Count: Count))
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return nil }
            if let json = try? JSON(data: count){
                let convert = json["valuteConvert"].doubleValue
                let count = json["count"].doubleValue
                let actualData = json["actualDateTime"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let formattedData = dateFormatter.date(from: actualData) {
                    
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                    let someDateTime = dateFormatter.string(from: formattedData)
                    return (convert,count,someDateTime)
                }
                else {
                    return nil
                }
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
