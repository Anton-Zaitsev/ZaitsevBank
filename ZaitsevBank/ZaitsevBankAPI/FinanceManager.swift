//
//  FinanceManager.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 02.06.2022.
//

import Foundation
import UIKit

public class FinanceManager {
    
    public func GetFinanceMonth() async -> [ExpensesMonth] {
        
        var FinanceMonth : [ExpensesMonth] = []
        
        if (UserDefaults.standard.checkUserID()) {
            
            let userID = UserDefaults.standard.isUserID()
            do {
                let (finance,responce) = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetFinanceMonth(userID: userID))
                guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                    return FinanceMonth }
                let financeMonth = try JSONDecoder().decode([Expenses].self, from: finance)
                
                for finace in financeMonth {
                    let valuteType = ValuteZaitsevBank.init(rawValue: finace.valuteType)!
                    let valueMonth = "\(finace.summ.convertedToMoneyValute(valute: valuteType)) \(valuteType.description)"
                    var arrayCategory : [CGFloat] = []
                    arrayCategory.append(finace.transfers)
                    arrayCategory.append(finace.buyValute)
                    arrayCategory.append(finace.saleValute)
                    arrayCategory.append(finace.transferCredit)
                    arrayCategory.append(finace.other)
                    
                    FinanceMonth.append(ExpensesMonth(title: valueMonth, category: arrayCategory))
                }
                return FinanceMonth
            }
            catch {
                return FinanceMonth
            }
        }
        else {
            return FinanceMonth
        }
    }
}
