//
//  API.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.10.2021.
//

import Foundation
import SwiftSoup
import SWXMLHash

public class API {
    
    
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
    
    public static func getValuteTableFull() async -> [ExchangeFull] {
        
        var dataCB : [ExchangeFull] = []
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
                
                guard let dataChart = await API_DinamicValute.GetDinamicValute(idValute: value.id) else {
                    continue
                }
                let valuteBuy = value.value / Double(value.nominal)
                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                dataCB.append(ExchangeFull(IDValute: value.id, charCode: value.charCode, nameValute: value.name, changesBuy: value.value > value.previous, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart))
                    
            }
            return dataCB
        }
        catch {
            print("Ошибка при декодинге")
            return dataCB
        }
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
        
        for value in BitcoinValutyType.allValuesFromTable {
            
            let getBit = URL(string: "https://api.cryptonator.com/api/ticker/\(value.rawValue)-usd")
            let request = URLRequest(url: getBit!)
                        
            do {
                
                let (dataBitcoin,responce)  = try await URLSession.shared.data(for: request)
                guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                    print("Не скачалась дата")
                    continue }
                
                let json = try JSONEncoder.newJSONDecoder().decode(BitcoinValutes.self, from: dataBitcoin)
                
                let data = json.ticker
                
                if let ExchangeBuy = Double(data.price) {
                    
                    if let ExchengeChange = Double(data.change){
                        
                        let valuteSale = ExchangeBuy + Double.random(in: -3..<3)
                        
                        dataBit.append(Exchange(typeValute: data.base, nameValute: BitcoinValutyType(rawValue: data.base)?.description ?? "USD", typeValuteExtended: data.base, buyValute: ExchangeBuy.valuteToTableFormat(), chartBuy: ExchengeChange > 0, saleValute: valuteSale.valuteToTableFormat(), chartSale: Bool.random()))
                    }
                }
            }
            catch {
                continue
            }
        }
        return dataBit
    }
    
    public static func getBitcoinTableFull() async -> [ExchangeFull] {
        
        var dataCB : [ExchangeFull] = []
        let getBit = URL(string: "https://api.coincap.io/v2/assets")
        
        var request = URLRequest(url: getBit!)
        request.setValue("Bearer \(SettingApp.APICoinCap)", forHTTPHeaderField: "Authorization")
        request.setValue("gzip,deflate,br", forHTTPHeaderField: "Accept-Encoding")
        
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return dataCB }
            
            let json = try JSONEncoder.newJSONDecoder().decode(BitcoinTableFullData.self, from: dataValue)
            
            for bit in json.data {
                if let valuteBuy = Double(bit.priceUsd!){
                    if let changes = Double(bit.changePercent24Hr!){
                        
                        let valuteSale = valuteBuy + Double.random(in: -3..<3)
                        
                        guard let dataChart = await API_DinamicValute.GetDinamicCriptoValute(nameValute: bit.name!) else {
                            continue
                        }
                        dataCB.append(ExchangeFull(IDValute: bit.id!, charCode: bit.symbol!, nameValute: bit.name!, changesBuy: changes > 0, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart))

                    }
                }
            }
            
            return dataCB
        }
        catch {
            print("Ошибка при декодинге")
            return dataCB
        }
    }
    
}

public extension JSONEncoder {
    
    static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    static func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
}


public extension Double {
     func valuteToTableFormat() -> String {
        let valute = String(format: "%.2f", self)
        return valute.replacingOccurrences(of: ".", with: ",")
    }
}


