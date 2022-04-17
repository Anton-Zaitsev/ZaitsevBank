//
//  API_VALUTE.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation
import SwiftyJSON

public class API_VALUTE {
    
    public static func getDataValute() async -> ([ValuteMainLabel],[Exchange]) {
        var arrayValute : [ValuteMainLabel] = []
        var dataCB : [Exchange] = []
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetPopListValute(ElectronValute: false))
            
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return (arrayValute,dataCB) }
            
            if let json = try? JSON(data: dataValue) {
                
                for (_,subJson):(String, JSON) in json {
                    
                    //let idValute = subJson["idValute"].stringValue
                    let charCode = subJson["charCode"].stringValue
                    let nameValute = subJson["nameValute"].stringValue
                    let chagesBuy = subJson["changesBuy"].boolValue
                    let valuteBuy = subJson["valuteBuy"].doubleValue
                    let changesSale = subJson["changesSale"].boolValue
                    let valuteSale =  subJson["valuteSale"].doubleValue
                    
                    let valuteChanges = chagesBuy ? "+\(Double.random(in: 1...3).valuteToTableFormat())" : Double.random(in: 1...3).valuteToTableFormat()
                    
                    arrayValute.append(ValuteMainLabel(nameValute: nameValute, countValute: valuteBuy.valuteToTableFormat() + " рублей", changes: valuteChanges, ValuePlus: chagesBuy))
                    
                    dataCB.append(Exchange(typeValute: charCode, nameValute: nameValute, typeValuteExtended: charCode, buyValute: valuteBuy.valuteToTableFormat(), chartBuy: chagesBuy, saleValute: valuteSale.valuteToTableFormat(), chartSale: changesSale))
                }
                
            }
            return (arrayValute,dataCB)
            
            
        }
        catch {
            print("Ошибка при декодинге")
            return (arrayValute,dataCB)
        }
        
    }
    
    public static func getBitcoinTable() async -> [Exchange]{
        var dataBit : [Exchange] = []
        do {
            
            let (dataBitcoin,responce)  = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetPopListValute(ElectronValute: true))
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return dataBit }
            
            if let json = try? JSON(data: dataBitcoin){
                
                for (_,subJson):(String, JSON) in json {
                    
                    let charCode = subJson["charCode"].stringValue
                    let nameValute = subJson["nameValute"].stringValue
                    let chagesBuy = subJson["changesBuy"].boolValue
                    let valuteBuy = subJson["valuteBuy"].doubleValue
                    let changesSale = subJson["changesSale"].boolValue
                    let valuteSale =  subJson["valuteSale"].doubleValue
                    
                    dataBit.append(Exchange(typeValute: charCode, nameValute: nameValute, typeValuteExtended: charCode, buyValute: valuteBuy.valuteToTableFormat(), chartBuy: chagesBuy, saleValute: valuteSale.valuteToTableFormat(), chartSale: changesSale))
                }
            }
            return dataBit
            
        }
        catch {
            return dataBit
        }
    }
    
    public static func sortedValute (dataInput: [ExchangeFull],_ cripto: Bool) -> [ExchangeFull] {
        
        var mass_valute : [String] = []
        if (cripto) {
            mass_valute = ["BTC", "ETH", "USDT", "DOGE", "LTC", "BCH", "DASH", "ALGO"].reversed()
        }
        else {
            mass_valute = ["USD", "EUR", "BYN" ,"UAH"].reversed()
        }
        
        let order = Dictionary(uniqueKeysWithValues: mass_valute.enumerated().map { ($0.1, $0.0) })
        
        let results = dataInput.sorted {
            (order[$0.charCode] ?? 0) > (order[$1.charCode] ?? 0)
        }
        
        return results
    }
}
