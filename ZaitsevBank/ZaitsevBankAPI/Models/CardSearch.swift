//
//  CardSearch.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 05.05.2022.
//

import Foundation

public class CardSearch: Codable {
    
    public var NameUser: String = ""

    public var TransactionCard: String = ""

    public var PhoneNumber: String = ""

    public var IdeticalValute: Bool

    public var ValuteSender: String = "" // Отправитель
    
    public var ValuteReceiver: String = "" // Получатель
    
    public var CardFirst: CardModel
    
    enum CodingKeys: String, CodingKey {
            case NameUser = "NameUser"
            case TransactionCard = "TransactionCard"
            case PhoneNumber = "PhoneNumber"
            case IdeticalValute = "IdeticalValute"
            case ValuteSender = "ValuteSender"
            case ValuteReceiver = "ValuteReceiver"
            case CardFirst = "CardFirst"
    }
}
