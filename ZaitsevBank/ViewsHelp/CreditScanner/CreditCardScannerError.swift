//
//  CreditCardScannerError.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.03.2022.
//
import Foundation

public struct CreditCardScannerError: LocalizedError {
    public enum Kind { case cameraSetup, photoProcessing, authorizationDenied, capture }
    public var kind: Kind
    public var underlyingError: Error?
    public var errorDescription: String? { (underlyingError as? LocalizedError)?.errorDescription }
}
