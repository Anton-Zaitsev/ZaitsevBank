//
//  Ecryption.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 12.10.2021.
//

import Foundation
import RNCryptor
import CommonCrypto

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

public struct AES {
    
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            print("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            print("Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    public func encrypt(string: String) -> String? {
        if let data = crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt)){
            return data.base64EncodedString()
        }
        else {
            return nil
        }
    }
    
    public func decrypt(data: Data) -> Data? {        
        if let encryptedData = crypt(data: Data(base64Encoded: data), option: CCOperation(kCCDecrypt)){
            return encryptedData
        }
        else {
            return nil
        }
    }
    
    private func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            print("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
