//
//  HistoryOperationPayments.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.04.2022.
//

import Foundation
import UIKit

public struct HistoryOperationPayments {
    public let defaultOperation : Bool = true
    public let typeOperation : OperationPayments
    public let iconOperation : UIImage
    public let nameOperation : String
}
public class HistoryPayment{
    
    public var HistoryOperationHeader : [HistoryOperationPayments] = []
    public var OperationTransfer : [HistoryOperationPayments] = []
    public var OperationPayment : [HistoryOperationPayments] = []
    
    init() {
        HistoryOperationHeader = getHistory()
        
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.toClientZaitsevBank, iconOperation: UIImage(named: "LogoZaitsevBank")!, nameOperation: "Клиенту ZaitsevBank"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.betweenYour, iconOperation: UIImage(systemName: "arrow.up.arrow.down")!, nameOperation: "Между своими"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.transferFromCamera, iconOperation: UIImage(systemName: "camera.shutter.button")!, nameOperation: "Перевод по сканеру карты"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.makeCredit, iconOperation: UIImage(systemName: "creditcard")!, nameOperation: "Оформить кредит"))
        
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.buyValute, iconOperation: UIImage(systemName: "dollarsign.circle")!, nameOperation: "Купить валюту"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.saleValute, iconOperation: UIImage(systemName: "eurosign.circle")!, nameOperation: "Продать валюту"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.creditPayment, iconOperation: UIImage(systemName: "building.columns")!, nameOperation: "Оплатить кредит"))
    }
    
    private func getHistory() -> [HistoryOperationPayments] {
        var operation: [HistoryOperationPayments]  = []
        let operationMoneyTransfer = HistoryOperationPayments(typeOperation: OperationPayments.transferFromCamera, iconOperation: UIImage(systemName: "camera.shutter.button")!, nameOperation: "Перевод по сканеру карты")
        let operationMoneyTransfer2 = HistoryOperationPayments(typeOperation: OperationPayments.toClientZaitsevBank, iconOperation: UIImage(systemName: "arrow.uturn.forward")!, nameOperation: "Перевести деньги")
        operation.append(operationMoneyTransfer)
        operation.append(operationMoneyTransfer2)
        return operation
    }
}
