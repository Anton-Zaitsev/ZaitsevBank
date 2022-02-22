//
//  Ecryption.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 12.10.2021.
//

import Foundation
import RNCryptor

extension String {
    func encryptMessage(encryptionKey: String) throws -> String {
        let messageData = self.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage(encryptionKey: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: self)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        return decryptedString
    }
    
}

public class Ecryption{
    
    public static func generateEncryptionKey(withPassword password:String) throws -> String {
        let randomData = RNCryptor.randomData(ofLength: 10)
        let cipherData = RNCryptor.encrypt(data: randomData, withPassword: password)
        return cipherData.base64EncodedString()
    }
}

