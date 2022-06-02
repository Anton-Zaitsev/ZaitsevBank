//
//  Expenses.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 02.06.2022.
//

import Foundation
import UIKit

public class Expenses : Codable{
    
    public var valuteType : String
    
    public var summ : Double
    
    public var transfers : Double // Категория переводов количество для линии заполнения
    
    public var buyValute : Double
    
    public var saleValute : Double
    
    public var transferCredit: Double
    
    public var other : Double
    
}

public struct ExpensesMonth {
    public let title : String
    public let category : [CGFloat]
    public let categoryColor : [UIColor] = [UIColor("#FF1F49")!,UIColor("#FF8A00")!,UIColor("#786CFE")!,UIColor("#64F1B7")!,UIColor("#0063FE")!]
}
