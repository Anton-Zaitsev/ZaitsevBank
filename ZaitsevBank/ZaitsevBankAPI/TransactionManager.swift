//
//  TransactionManager.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import Foundation

public class TransactionManager {
    
    public func AddMoneyCredit(transactionCredit: String, transactionCard: String, creditID: String) async -> Bool{
        let request : URLRequest = ClienZaitsevBankAPI.getRequestAddMoneyCredit(transactionCredit: transactionCredit, transactionCard: transactionCard, creditID: creditID)
        do {
            let (_,responce) = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return false }
            return true
        }
        catch {
            return false
        }
    }
    public func ApplyCredit(summ: Double,year: Int, transactionCard: String) async -> Bool{
        
        var request : URLRequest
        
        if let summInt = Int(exactly: summ){
            request = ClienZaitsevBankAPI.getRequestApplyCredit(count: String(summInt), year: String(year), transactionCard: transactionCard)
        }
        else {
            let summString = String(summ).replacingOccurrences(of: ".", with: ",")
            request = ClienZaitsevBankAPI.getRequestApplyCredit(count: summString, year: String(year), transactionCard: transactionCard)
        }
        
        do {
            let (_,responce) = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return false }
            return true
        }
        catch {
            return false
        }
        
    }
    
    public func CheckCredit(summ: Double, year: Int) async -> CreditCheck? {
        
        var request : URLRequest
        if let summInt = Int(exactly: summ){
            request = ClienZaitsevBankAPI.getRequestCheckCredit(count: String(summInt), year: String(year))
        }
        else {
            let summString = String(summ).replacingOccurrences(of: ".", with: ",")
            request = ClienZaitsevBankAPI.getRequestCheckCredit(count: summString, year: String(year))
        }
        do {
            let (credit,responce) = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return nil }
            let decoder = JSONDecoder()
            let creditCheck = try decoder.decode(CreditCheck.self, from: credit)
            return creditCheck
        }
        catch {
            return nil
        }
    }
    
    public func GetListCredits(allList: Bool = false) async -> [SortedAllCreditList]? {
        if (UserDefaults.standard.checkUserID()) {
            
            let userID = UserDefaults.standard.isUserID()
            let request : URLRequest = ClienZaitsevBankAPI.getRequestGetListCredits(userID: userID,allList: allList)
            
            do {
                let (ListCredit,responce) = try await URLSession.shared.data(for: request)
                guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                    return nil }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategyFormatters = [DateFormatter.standardF,DateFormatter.standardT,
                                                          DateFormatter.standard]
                let AllCreditList = try decoder.decode([CreditPay].self, from: ListCredit)
                
                let dateformat = DateFormatter()
                dateformat.dateFormat = "d MMMM yyyy"
                
                let creditSorted = AllCreditList.reduce([SettingsCredit: [CreditPaysTransaction]]()) { (key, value) -> [SettingsCredit: [CreditPaysTransaction]] in
                    var key = key
                    let dataOffers = dateformat.string(from: value.dateCreditOffers)
                    let dataEnd = dateformat.string(from: value.dateCreditEnd)
                    let nameKey = "№ \(value.numberDocument) от \(dataOffers) г. до \(dataEnd) г."
                    
                    let settingsCredit : SettingsCredit = SettingsCredit(nameCredit: nameKey, dateCredit: value.dateCreditOffers,creditID: value.idCredit)
                    
                    var array = key[settingsCredit]
                    
                    if array == nil {
                        array = []
                    }
                    array = value.creditPaysTransaction
                    key[settingsCredit] = array!.sorted(by: { $0.datePay < $1.datePay })
                    
                    return key
                }
                var sortedAllCredits : [SortedAllCreditList] = []
                
                for transaction in creditSorted{
                    sortedAllCredits.append(SortedAllCreditList(SettingsCredit: transaction.key, credits: transaction.value))
                }
                sortedAllCredits = sortedAllCredits.sorted(by: { $0.SettingsCredit.dateCredit < $1.SettingsCredit.dateCredit })
                
                return sortedAllCredits
            }
            catch {
                return nil
            }
            
        }
        else {
            return nil
        }
    }
    
    public func TransferClient(TransactionSender: String, TransactionRecipient: String, summ: Double) async -> Bool{
        
        var request : URLRequest
        
        if let summInt = Int(exactly: summ){
            request = ClienZaitsevBankAPI.getRequestTransferClient(TransactionSender: TransactionSender, TransactionRecipient: TransactionRecipient, summ: String(summInt))
        }
        else {
            let summString = String(summ).replacingOccurrences(of: ".", with: ",")
            request = ClienZaitsevBankAPI.getRequestTransferClient(TransactionSender: TransactionSender, TransactionRecipient: TransactionRecipient, summ: summString)
        }
        
        do {
            let (_,responce) = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return false }
            return true
        }
        catch {
            return false
        }
    }
    
    public func ValuteBuySale(transactionCardA: String, transactionCardB: String,Summ: Double, BuySale: Bool) async -> Bool{
        
        var request : URLRequest
        
        if let summInt = Int(exactly: Summ){
            request = ClienZaitsevBankAPI.getRequestValuteBuySale(transactionCardA: transactionCardA, transactionCardB: transactionCardB, Summ: String(summInt), BuySale: BuySale)
        }
        else {
            let summString = String(Summ).replacingOccurrences(of: ".", with: ",")
            request = ClienZaitsevBankAPI.getRequestValuteBuySale(transactionCardA: transactionCardA, transactionCardB: transactionCardB, Summ: summString, BuySale: BuySale)
        }
        
        do {
            let (_,responce) = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return false }
            return true
        }
        catch {
            return false
        }
    }
    
    public func GetAllTransaction(_ dateFrom: Date? = nil, _ dateTo: Date? = nil) async -> [SortedAllTransaction]?{
        
        if (UserDefaults.standard.checkUserID()) {
            
            let userID = UserDefaults.standard.isUserID()
            
            let DateTo = dateTo == nil ? Date.now : dateTo!
            
            var DateFrom : Date
            
            if (dateFrom != nil){
                DateFrom = dateFrom!
            }
            else {
                let calendar = Calendar.current
                DateFrom = calendar.date(byAdding: .month, value: -1, to: DateTo)!
            }
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd.MM.yyyy"
            let dataFromString =  dateformat.string(from: DateFrom)
            let dataToString = dateformat.string(from: DateTo)
            
            do {
                let (ListTransaction,responce) = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetAllTransactiont(userID: userID, DateFrom: dataFromString, DateTo: dataToString))
                guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                    return nil }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategyFormatters = [DateFormatter.standardT,
                                                          DateFormatter.standard]
                let AllTransaction = try decoder.decode([AllTransactions].self, from: ListTransaction)
                
                dateformat.dateFormat = "d MMMM, E"
                
                let transactionSorted = AllTransaction.reduce([String: [AllTransactions]]()) { (key, value) -> [String: [AllTransactions]] in
                    var key = key
                    let data = dateformat.string(from: value.dateTime)
                    var array = key[data]
                    
                    if array == nil {
                        array = []
                    }
                    array!.append(value)
                    key[data] = array!.sorted(by: { $0.dateTime > $1.dateTime })
                    
                    return key
                }
                var sortedAllTransactions : [SortedAllTransaction] = []
                
                for transaction in transactionSorted{
                    sortedAllTransactions.append(SortedAllTransaction(date: transaction.key, allTransactions: transaction.value))
                }
                sortedAllTransactions = sortedAllTransactions.sorted(by: { dateformat.date(from: $0.date)! > dateformat.date(from:$1.date)!})
                
                return sortedAllTransactions
            }
            catch {
                return nil
            }
        }
        else {
            return nil
        }
        
    }
}
extension JSONDecoder {
    var dateDecodingStrategyFormatters: [DateFormatter]? {
        @available(*, unavailable, message: "Эта переменная предназначена только для установки")
        get { return nil }
        set {
            guard let formatters = newValue else { return }
            self.dateDecodingStrategy = .custom { decoder in
                
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Не удается декодировать строку данных \(dateString)")
            }
        }
    }
}

extension DateFormatter {
    static let standardT: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        return dateFormatter
    }()
    static let standardF: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
}
