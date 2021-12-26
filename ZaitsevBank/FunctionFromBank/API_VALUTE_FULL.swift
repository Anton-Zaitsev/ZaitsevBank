//
//  API_VALUTE_FULL.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation

public class API_VALUTE_FULL {
    
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
                
                guard let dataChart = await API_DinamicValute.GetDinamicValuteFromDay(idValute: value.id) else {
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
                        
                        guard let dataChart = await API_DinamicValute.GetDinamicCriptoValuteFromDay(nameValute: bit.name!) else {
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
