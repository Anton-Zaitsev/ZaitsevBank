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
    
    public static func getValuteTable() async -> [Exchange] {
        
        var dataCB : [Exchange] = []
        
        let valute = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        guard let dataValue = await getData(url: valute!) else {
            print("Не скачалась дата")
            return dataCB }
        
        do {
            
            let json = try newJSONDecoder().decode(ValuteCb.self, from: dataValue)
            for data in json.valute {
                let value = data.value
                
                let valuteBuy = value.value / Double(value.nominal)
                
                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                dataCB.append(Exchange(typeValute: ValuteType(rawValue: value.charCode)?.description ?? "N", nameValute: value.name, typeValuteExtended: value.charCode, buyValute: String(format: "%.2f", valuteBuy), chartBuy: value.value > value.previous, saleValute: String(format: "%.2f", valuteSale), chartSale: Bool.random()))
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
        
        
        // FULL API https://api.cryptonator.com/api/full/DOGE-usd
        
        //let bitcoin = URL(string: "http://api.bitcoincharts.com/v1/markets.json")
        
        for value in BitcoinValutyType.allValuesFromTable {
            
            let getBit = URL(string: "https://api.cryptonator.com/api/ticker/\(value.rawValue)-usd")
            
            guard let dataBitcoin = await getData(url: getBit!) else {
                print("Не скачалась дата")
                continue }
            
            do {
                let json = try newJSONDecoder().decode(BitcoinValutes.self, from: dataBitcoin)
                
                let data = json.ticker
                
                if let ExchangeBuy = Double(data.price) {
                   
                    if let ExchengeChange = Double(data.change){
                        
                        let valuteSale = ExchangeBuy + Double.random(in: -3..<3)
                        
                        dataBit.append(Exchange(typeValute: data.base, nameValute: BitcoinValutyType(rawValue: data.base)?.description ?? "USD", typeValuteExtended: data.base, buyValute: String(format: "%.2f",ExchangeBuy), chartBuy: ExchengeChange > 0, saleValute: String(format: "%.2f",valuteSale), chartSale: Bool.random()))
                    }
                }
            }
            catch {
               continue
            }
        }
        return dataBit
    }
    
    
    fileprivate static func getData(url : URL) async -> Data? {
        do {
            let (data,responce) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            return data
        }
        catch{
            return nil
        }
    }
    
    fileprivate static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    fileprivate static func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
}



