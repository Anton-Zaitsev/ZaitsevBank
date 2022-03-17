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
        
        let valute = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        let request = URLRequest(url: valute!)
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return (arrayValute,dataCB) }
            
            if let json = try? JSON(data: dataValue) {
                
                let jsonValute = json["Valute"].dictionaryValue
                
                if let dataUSD = jsonValute.first(where:{$0.value["CharCode"].string == ValuteType.USD.rawValue}) {
                     
                    let valueValute = dataUSD.value["Value"].double ?? 0
                    let valuePrevious = dataUSD.value["Previous"].double ?? 0
                    let valuteName = dataUSD.value["Name"].string ?? "None"
                    
                    let changes = valueValute - valuePrevious
                    let changesBool = changes >= 0
                    let valueDOLLAR = ValuteMainLabel(nameValute: valuteName, countValute: valueValute.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                    arrayValute.append(valueDOLLAR)
                }
                
                if let dataEvro = jsonValute.first(where:{$0.value["CharCode"].string == ValuteType.EUR.rawValue}) {
                    
                    let valueValute = dataEvro.value["Value"].double ?? 0
                    let valuePrevious = dataEvro.value["Previous"].double ?? 0
                    let valuteName = dataEvro.value["Name"].string ?? "None"
                    
                    let changes = valueValute - valuePrevious
                    let changesBool = changes >= 0
                    
                    let valueEVRO = ValuteMainLabel(nameValute: valuteName, countValute: valueValute.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                    
                    arrayValute.append(valueEVRO)
                }
                
                if let dataUKR = jsonValute.first(where:{$0.value["CharCode"].string == ValuteType.UAH.rawValue}) {
                    
                    let valueValute = dataUKR.value["Value"].double ?? 0
                    let valuePrevious = dataUKR.value["Previous"].double ?? 0
                    let valuteName = dataUKR.value["Name"].string ?? "None"
                    
                    let changes = valueValute - valuePrevious
                    let changesBool = changes >= 0
                    
                    let valueYkraina = ValuteMainLabel(nameValute: valuteName, countValute: valueValute.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                    
                    arrayValute.append(valueYkraina)
                }
                
                for data in jsonValute {
                    let value = data.value
                    
                    if let valueValute = value["Value"].double{
                        if let valuePrevious = value["Previous"].double{
                            if let charCodeValute = value["CharCode"].string {
                                
                                let nominalValute = value["Nominal"].double ?? 1
                                let valuteBuy = valueValute / nominalValute
                                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                                let nameValute = value["Name"].stringValue
                                
                                dataCB.append(Exchange(typeValute: ValuteType(rawValue: charCodeValute)?.description ?? "None", nameValute: nameValute, typeValuteExtended: charCodeValute, buyValute: valuteBuy.valuteToTableFormat(), chartBuy: valueValute > valuePrevious, saleValute: valuteSale.valuteToTableFormat(), chartSale: Bool.random()))
                            }
                        }
                    }
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
        let ListBitcoin = ["bitcoin","ethereum","tether"]
        for value in ListBitcoin {
            
            let getBit = URL(string: "https://api.coincap.io/v2/assets/\(value)")
            var request = URLRequest(url: getBit!)
            request.setValue("Bearer \(SettingApp.APICoinCap)", forHTTPHeaderField: "Authorization")
            request.setValue("gzip,deflate,br", forHTTPHeaderField: "Accept-Encoding")
                        
            do {
                
                let (dataBitcoin,responce)  = try await URLSession.shared.data(for: request)
                guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                    print("Не скачалась дата")
                    continue }
                
                if let json = try? JSON(data: dataBitcoin){
                    
                    let data = json["data"]
                    
                    if let ExchangeBuy = Double(data.dictionaryValue["priceUsd"]?.string ?? "none") {
                        if let ExchengeChange = Double(data.dictionaryValue["changePercent24Hr"]?.string ?? "none"){
                            
                            let valuteSale = ExchangeBuy + Double.random(in: -3..<3)
                            
                            dataBit.append(Exchange(typeValute: (data.dictionaryValue["symbol"]?.stringValue ?? "none") , nameValute: data.dictionaryValue["name"]?.stringValue ?? "none", typeValuteExtended: data.dictionaryValue["symbol"]?.stringValue ?? "none", buyValute: ExchangeBuy.valuteToTableFormat(), chartBuy: ExchengeChange > 0, saleValute: valuteSale.valuteToTableFormat(), chartSale: Bool.random()))
                            
                        }
                    }
                }
        
            }
            catch {
                continue
            }
        }
        return dataBit
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
