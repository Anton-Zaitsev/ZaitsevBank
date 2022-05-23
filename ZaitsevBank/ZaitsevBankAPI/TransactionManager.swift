//
//  TransactionManager.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import Foundation

public class TransactionManager {
    
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
                print(String(decoding: ListTransaction, as: UTF8.self))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategyFormatters = [DateFormatter.standardT,
                                                           DateFormatter.standard]
                let AllTransaction = try decoder.decode([AllTransactions].self, from: ListTransaction)
    
                print(AllTransaction.count)
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
            catch (let error) {
                print(error.localizedDescription)
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
    static let standard: DateFormatter = {
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateFormatter
    }()
}
