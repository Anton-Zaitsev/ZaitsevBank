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
        
        if let summintVal = Int(doubleVal: summ){
            request = ClienZaitsevBankAPI.getRequestTransferClient(TransactionSender: TransactionSender, TransactionRecipient: TransactionRecipient, summ: String(summintVal))
        }
        else {
            let summString = String(summ).replacingOccurrences(of: ",", with: ".")
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
}
