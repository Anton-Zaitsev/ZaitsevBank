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
            
            await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
             
                for data in json.valute {
                    taskGroup.addTask {
                            let value = data.value
                            let downloadedDinamic = await self.getDinamicParalles(_data: value)
                            return downloadedDinamic
                        }
                }
                
                for await dataDownload in taskGroup {
                    if let data = dataDownload {
                        dataCB.append(data)
                    }
                }
            }
            
            return dataCB.sorted { $0.charCode < $1.charCode }
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
             
            await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
             
                for index in 0..<json.data.count {
                    taskGroup.addTask {
                            
                            let data = json.data[index]
                            let downloadedDinamic = await self.getDinamicBitParalles(_data: data)
                            return downloadedDinamic
                        }
                    }
                
                for await dataDownload in taskGroup {
                    if let data = dataDownload {
                        dataCB.append(data)
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
    
    private static func getDinamicBitParalles(_data: BitcoinTableData) async -> ExchangeFull?  {
        
        if let valuteBuy = Double(_data.priceUsd!){
            if let changes = Double(_data.changePercent24Hr!){
                
                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                guard let dataChart = await API_DinamicValute.GetDinamicCriptoValuteFromDay(nameValute: _data.name!) else {
                    return nil
                }
                return ExchangeFull(IDValute: _data.id!, charCode: _data.symbol!, nameValute: _data.name!, changesBuy: changes > 0, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart)

            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    private static func getDinamicParalles(_data: Valute) async -> ExchangeFull?  {
        
        guard let dataChart = await API_DinamicValute.GetDinamicValuteFromDay(idValute: _data.id) else {
            return nil
        }
        let valuteBuy = _data.value / Double(_data.nominal)
        let valuteSale = valuteBuy + Double.random(in: -3..<3)
        
        return ExchangeFull(IDValute: _data.id, charCode: _data.charCode, nameValute: _data.name, changesBuy: _data.value > _data.previous, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart)
    }
}
