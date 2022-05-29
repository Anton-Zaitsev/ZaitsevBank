//
//  CreditPay.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.05.2022.
//

import Foundation

public struct SettingsCredit : Hashable  {
    public static func == (lhs: SettingsCredit, rhs: SettingsCredit) -> Bool {
        return lhs.nameCredit == rhs.nameCredit && lhs.dateCredit == rhs.dateCredit && lhs.creditID == rhs.creditID
    }
    
    var nameCredit : String = ""
    var dateCredit : Date
    var creditID : String = ""
    
    init(nameCredit: String, dateCredit: Date,creditID: String) {
            self.nameCredit = nameCredit
            self.dateCredit = dateCredit
            self.creditID = creditID
    }
}


public struct SortedAllCreditList {
    public var SettingsCredit : SettingsCredit
    public var credits: [CreditPaysTransaction] = []
}
public class CreditPay : Codable{
    public var idCredit : String
    public var numberDocument : String
    public var dateCreditOffers : Date// Дата кредита оформления
    public var dateCreditEnd: Date// Дата окончания кредита
    public var creditPaysTransaction : [CreditPaysTransaction]
}
public class CreditPaysTransaction : Codable {
    public var idTransaction : String
    public var overdue: Bool // Просроченный
    public var waiting : Bool // Ожидающий прямо сейчас
    public var datePay : Date // Дата транзакции кредита
    public var summCredit : Double = 0
    public var balanceCredit: Double = 0
}
