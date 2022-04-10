//
//  CardModel.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.04.2022.
//

import Foundation

public class CardModel: Codable {
    
    public var CardID: String = ""

    public var UserID: String = ""

    public var CardOperator: String = ""

    public var ClosedCard: Bool

    public var CVV : String = ""

    public var DataClosedCard: String
    
    public var MoneyCard: Double

    public var NameCard: String = ""

    public var NumberCard: String = ""
    
    public var TypeMoney: String = ""

    public var TransactionCard: String = ""
    
}

typealias CardModelArray = [CardModel]
