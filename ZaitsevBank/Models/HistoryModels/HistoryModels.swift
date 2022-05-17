//
//  HistoryModels.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 17.05.2022.
//

import Foundation
import UIKit

public class HistoryTransactionModels {
    
    public var HistoryOperation : [HistoryTransactionModel] = [HistoryTransactionModel]()
    public var TransactionFilterOperation : [TransactionFilter] = [TransactionFilter]()
    
    init() {
        HistoryOperation.append(HistoryTransactionModel(ImageOperation: UIImage(systemName: "chart.pie.fill")!, NameOperation: "Анализ расходов", transaction: .costAnalysis))
        HistoryOperation.append(HistoryTransactionModel(ImageOperation: UIImage(systemName: "list.bullet.rectangle.portrait.fill")!, NameOperation: "Фильтры", transaction: .filter))
        
        TransactionFilterOperation.append(TransactionFilter(NameFilter: "Тип операции", ClickFilter: false, Filter: .typeOperation))
        TransactionFilterOperation.append(TransactionFilter(NameFilter: "Период", ClickFilter: false, Filter: .period))
        TransactionFilterOperation.append(TransactionFilter(NameFilter: "Карта", ClickFilter: false, Filter: .cardAccount))
        TransactionFilterOperation.append(TransactionFilter(NameFilter: "Сумма", ClickFilter: false, Filter: .summ))
    }
}

public struct HistoryTransactionModel {
    public let ImageOperation: UIImage
    public var NameOperation : String
    public let transaction : HistoryTransaction
}
public struct TransactionFilter {
    public var NameFilter : String
    public var ClickFilter : Bool
    public let Filter : HistoryTransaction
}
public enum HistoryTransaction {
    case costAnalysis // Анализ расходов
    case filter // Фильтр
    case typeOperation // Тип операции
    case period // Период
    case cardAccount  // Карты аккаунта
    case summ // Сумма
}

