//
//  CheckCredit.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 27.05.2022.
//

import Foundation

public class CreditCheck: Codable {
    public var paymentsCredits : [PaymentsCredit] = []
    public var summCredit: Double = 0
    public var monthCredit : Double  = 0
    public var persent : Float = 0
    public var overPayment : Float = 0
    public var monthlyPayment: Float  = 0
}
public class PaymentsCredit : Codable {
    public var month: Int = 0
    public var pay: Double = 0
    public var percents : Double = 0
    public var lastSumm : Double = 0;
}
