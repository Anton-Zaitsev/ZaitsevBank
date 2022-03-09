//
//  API_VALUTE.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation

public class API_VALUTE {
    
    public static func getDataValute() async -> [ValuteMainLabel] {
        var arrayValute : [ValuteMainLabel] = [ValuteMainLabel]()
        
        let valute = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        let request = URLRequest(url: valute!)
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return arrayValute }
            
            let json = try JSONEncoder.newJSONDecoder().decode(ValuteCb.self, from: dataValue)

                            
            if let dataUSD = json.valute.first(where:{$0.value.charCode == ValuteType.USD.rawValue}) {
                let data = dataUSD.value
                let changes = data.value - data.previous
                let changesBool = changes >= 0
                let valueDOLLAR = ValuteMainLabel(nameValute: data.name, countValute: data.value.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                arrayValute.append(valueDOLLAR)
            }
            
            if let dataEvro = json.valute.first(where:{$0.value.charCode == ValuteType.EUR.rawValue}) {
                let data = dataEvro.value
                let changes = data.value - data.previous
                let changesBool = changes >= 0
                let valueEVRO = ValuteMainLabel(nameValute: data.name, countValute: data.value.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                arrayValute.append(valueEVRO)
            }
            
            if let dataUKR = json.valute.first(where:{$0.value.charCode == ValuteType.UAH.rawValue}) {
                let data = dataUKR.value
                let changes = data.value - data.previous
                let changesBool = changes >= 0
                let valueYkraina = ValuteMainLabel(nameValute: data.name, countValute: data.value.valuteToTableFormat() + " рублей", changes: changesBool == true ? "+\(changes.valuteToTableFormat())" : changes.valuteToTableFormat(), ValuePlus: changesBool)
                arrayValute.append(valueYkraina)
            }
            return arrayValute
        }
        catch {
            print("Ошибка при декодинге")
            return arrayValute
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
