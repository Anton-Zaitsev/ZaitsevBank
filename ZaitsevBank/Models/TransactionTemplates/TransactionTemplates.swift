//
//  TransactionTemplates.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import Foundation
import UIKit

public enum TransactionOperationModel {
    case safeCheck // Сохранить чек
    case createPattern // Создать шаблон
    case operationDetails // Подробности операции

}

public struct TransactionOperations {
    public let defaultOperation : Bool = true
    public let typeOperation : TransactionOperationModel
    public let iconOperation : UIImage
    public let nameOperation : String
}

public class TransactionTemplatesOperation {
    
    public var TransactionOperation : [TransactionOperations] = []
    
    init() {
        TransactionOperation.append(TransactionOperations(typeOperation: TransactionOperationModel.safeCheck, iconOperation: UIImage(systemName: "wallet.pass")!, nameOperation: "Сохранить чек"))
        
        TransactionOperation.append(TransactionOperations(typeOperation: TransactionOperationModel.createPattern, iconOperation: UIImage(systemName: "arrow.down.doc.fill")!, nameOperation: "Создать шаблон"))
        
        TransactionOperation.append(TransactionOperations(typeOperation: TransactionOperationModel.operationDetails, iconOperation: UIImage(systemName: "info.circle")!, nameOperation: "Подробности операции"))
    }

}
