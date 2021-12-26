//
//  FullValuteMenu.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import Foundation

public class FullValuteMenu {
    var exchangeValute : [ExchangeFull] = []
    var exchangeValuteDefault : [ExchangeFull] = []
    var exchangeValuteCriptoValute : [ExchangeFull] = []
    let dataNow = "22.02.13"
}

public struct ExchangeFull {
    var IDValute : String
    
    var charCode: String
    var nameValute : String
    
    var changesBuy : Bool
    var buy : String
 
    var changesSale : Bool
    var sale : String
    
    var dataChar : [Double]
}

public struct DinamicValute {
    var value: [Double]
    var data : [String]
    var min : Double
    var max : Double
    var start : Double
    var now : Double
}
