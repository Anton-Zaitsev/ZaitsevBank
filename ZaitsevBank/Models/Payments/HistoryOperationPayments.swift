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

public struct HistoryOperationPaymentsList{
    public let name: String
    public let listOperation : [HistoryOperationPayments]
}

public class HistoryPayment{
    
    public var OperationAll : [HistoryOperationPaymentsList] = []
    
    public var HistoryOperationHeader : [HistoryOperationPayments] = []
    
    init() {
        HistoryOperationHeader = getHistory()
        
        var OperationTransfer = [HistoryOperationPayments]()
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.toClientZaitsevBank, iconOperation: UIImage(named: "LogoZaitsevBank")!, nameOperation: "Клиенту ZaitsevBank"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.betweenYour, iconOperation: UIImage(systemName: "arrow.up.arrow.down")!, nameOperation: "Между своими"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.transferFromCamera, iconOperation: UIImage(systemName: "camera.shutter.button")!, nameOperation: "Перевод по сканеру карты"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: OperationPayments.makeCredit, iconOperation: UIImage(systemName: "creditcard")!, nameOperation: "Оформить кредит"))
        
        var OperationPayment = [HistoryOperationPayments]()
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.buyValute, iconOperation: UIImage(systemName: "dollarsign.circle")!, nameOperation: "Купить валюту"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.saleValute, iconOperation: UIImage(systemName: "eurosign.circle")!, nameOperation: "Продать валюту"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: OperationPayments.creditPayment, iconOperation: UIImage(systemName: "building.columns")!, nameOperation: "Оплатить кредит"))
        
        OperationAll.append(HistoryOperationPaymentsList(name: "Перевести", listOperation: OperationTransfer))
        OperationAll.append(HistoryOperationPaymentsList(name: "Оплатить", listOperation: OperationPayment))
        
        OperationPayment.removeAll()
        OperationTransfer.removeAll()
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
