//
//  API_VALUTE.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation
import SwiftSoup
import SWXMLHash

public class API_VALUTE {
    
    public static func getDataValute() -> [ValuteMainLabel]  {
        var arrayValute : [ValuteMainLabel] = [ValuteMainLabel]()
        
        guard let url = URL(string: "https://www.banki.ru/products/currency/cb/") else {return arrayValute}
        do{
            let html = try String(contentsOf: url, encoding: .utf8)
            do {
                let doc = try SwiftSoup.parse(html)
                do {
                    let elementValute = try doc.select("td").array()
                    
                    let valueDOLLAR = ValuteMainLabel(nameValute: try elementValute[2].text(), countValute: try "$ \(elementValute[3].text())", changes: try elementValute[4].text(), ValuePlus: try elementValute[4].text().first == "+" ? true : false)
                    let valueEVRO = ValuteMainLabel(nameValute: try elementValute[7].text(), countValute:  try "€ \(elementValute[8].text())", changes: try elementValute[9].text(), ValuePlus: try elementValute[9].text().first == "+" ? true : false)
                    let valueYkraina = ValuteMainLabel(nameValute: try elementValute[137].text(), countValute:  try "₴ \(elementValute[138].text())", changes: try elementValute[139].text(), ValuePlus: try elementValute[139].text().first == "+" ? true : false )
                    arrayValute.append(valueDOLLAR)
                    arrayValute.append(valueEVRO)
                    arrayValute.append(valueYkraina)
                }
                catch let error {
                    print(error)
                }
            }
            catch let error {
                print(error)
            }
        }
        catch let error {
            print(error)
        }
        return arrayValute
    }
 
    
    
    public static func getValuteTable() async -> [Exchange] {
        
        var dataCB : [Exchange] = []
        
        let valute = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        let request = URLRequest(url: valute!)
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return dataCB }
            
            let json = try JSONEncoder.newJSONDecoder().decode(ValuteCb.self, from: dataValue)
            for data in json.valute {
                let value = data.value
                
                let valuteBuy = value.value / Double(value.nominal)
                
                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                dataCB.append(Exchange(typeValute: ValuteType(rawValue: value.charCode)?.description ?? "N", nameValute: value.name, typeValuteExtended: value.charCode, buyValute: valuteBuy.valuteToTableFormat(), chartBuy: value.value > value.previous, saleValute: valuteSale.valuteToTableFormat(), chartSale: Bool.random()))
            }
            return dataCB
        }
        catch {
            print("Ошибка при декодинге")
            return dataCB
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
                
                let json = try JSONEncoder.newJSONDecoder().decode(BitcoinValutes.self, from: dataBitcoin)
                
                let data = json.data
                
                if let ExchangeBuy = Double(data.priceUsd) {
                    
                    if let ExchengeChange = Double(data.changePercent24Hr){
                        
                        let valuteSale = ExchangeBuy + Double.random(in: -3..<3)
                        
                        dataBit.append(Exchange(typeValute: data.symbol, nameValute: data.name, typeValuteExtended: data.symbol, buyValute: ExchangeBuy.valuteToTableFormat(), chartBuy: ExchengeChange > 0, saleValute: valuteSale.valuteToTableFormat(), chartSale: Bool.random()))
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
