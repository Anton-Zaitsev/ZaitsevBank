//
//  ExtensionFuncBank.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation

public extension Double {
     func valuteToTableFormat() -> String {
        let valute = String(format: "%.2f", self)
        return valute.replacingOccurrences(of: ".", with: ",")
    }
}

