//
//  HistoryOperationPayments.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.04.2022.
//

import Foundation
import UIKit

public struct HistoryOperationPayments {
    public let typeOperation : String
    public let iconOperation : UIImage
    public let nameOperation : String
}
public class HistoryPayment{
    
    public var HistoryOperationHeader : [HistoryOperationPayments] = []
    public var OperationTransfer : [HistoryOperationPayments] = []
    public var OperationPayment : [HistoryOperationPayments] = []
    
    init() {
        HistoryOperationHeader = getHistory()
        
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(named: "LogoZaitsevBank")!, nameOperation: "Клиенту ZaitsevBank"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "arrow.up.arrow.down")!, nameOperation: "Между своими"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "camera.shutter.button")!, nameOperation: "Перевод по сканеру карты"))
        OperationTransfer.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "creditcard")!, nameOperation: "Другому человеку"))
        
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "iphone")!, nameOperation: "Оплата по QR или штрихкоду"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "building.2.fill")!, nameOperation: "Образование"))
        OperationPayment.append(HistoryOperationPayments.init(typeOperation: "Перевод", iconOperation: UIImage(systemName: "building.columns")!, nameOperation: "Оплатить кредит"))
    }
    
    private func getHistory() -> [HistoryOperationPayments] {
        var operation: [HistoryOperationPayments]  = []
        let operationMoneyTransfer = HistoryOperationPayments(typeOperation: "Перевод", iconOperation: UIImage(systemName: "camera.shutter.button")!, nameOperation: "Перевод по сканеру карты")
        let operationMoneyTransfer2 = HistoryOperationPayments(typeOperation: "Перевод", iconOperation: UIImage(systemName: "arrow.uturn.forward")!, nameOperation: "Перевести деньги")
        operation.append(operationMoneyTransfer)
        operation.append(operationMoneyTransfer2)
        return operation
    }
}
