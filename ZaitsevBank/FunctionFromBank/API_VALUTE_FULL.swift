//
//  API_VALUTE_FULL.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation
import SwiftyJSON

public class API_VALUTE_FULL {
    
    private let api  = API_DinamicValute()
    
    public func getValuteTableFull() async -> [ExchangeFull] {
        
        var dataCB : [ExchangeFull] = []
        let valute = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        let request = URLRequest(url: valute!)
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return dataCB }
                        
            if let json = try? JSON(data: dataValue) {
            
                let jsonValute = json["Valute"].dictionaryValue
                
                await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
                 
                    for data in jsonValute {
                        taskGroup.addTask {
                                let value = data.value
                                let downloadedDinamic = await self.getDinamicParalles(value)
                                return downloadedDinamic
                            }
                    }
                    
                    for await dataDownload in taskGroup {
                        if let data = dataDownload {
                            dataCB.append(data)
                        }
                    }
                }
                
                return API_VALUTE.sortedValute(dataInput: dataCB,false)
            }
            else {
                return dataCB
            }
        }
        catch {
            print("Ошибка при декодинге")
            return dataCB
        }
    }
    
    public func getBitcoinTableFull() async -> [ExchangeFull] {
        
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
            
            if let json = try? JSON(data: dataValue){
                
            let data = json["data"].arrayValue
             
            await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
             
                for value in data {
                    taskGroup.addTask {
                            
                            let data = value
                            let downloadedDinamic = await self.getDinamicBitParalles(data)
                            return downloadedDinamic
                        }
                    }
                
                for await dataDownload in taskGroup {
                    if let data = dataDownload {
                        dataCB.append(data)
                    }
                }
            }
                return API_VALUTE.sortedValute(dataInput: dataCB,true)
            }
            else {
                return dataCB
            }
        }
        catch {
            print("Ошибка при декодинге")
            return dataCB
        }
    }
    
    private func getDinamicBitParalles(_ data: JSON) async -> ExchangeFull?  {
        
        if let valuteBuy = Double(data["priceUsd"].string ?? ""){
            if let changes = Double(data["changePercent24Hr"].string ?? ""){
                if let valuteName = data["name"].string {
                    let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                    guard let dataChart = await api.GetDinamicCriptoValuteFromDay(nameValute: valuteName) else {
                        return nil }
                    
                    return ExchangeFull(IDValute: data["id"].stringValue, charCode: data["symbol"].stringValue, nameValute: valuteName, changesBuy: changes > 0, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart)
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    private func getDinamicParalles(_ data: JSON) async -> ExchangeFull?  {
        
        if let ID = data["ID"].string {
            guard let dataChart = await api.GetDinamicValuteFromDay(idValute: ID) else {
                return nil
            }
            if let valueValute = data["Value"].double{
                if let valuePrevious = data["Previous"].double{
                
                    let valuteBuy = valueValute / (data["Nominal"].double ?? 1)
                    let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                    return ExchangeFull(IDValute: ID, charCode: data["CharCode"].stringValue, nameValute: data["Name"].stringValue, changesBuy: valueValute > valuePrevious, buy: valuteBuy.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), dataChar: dataChart)
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}
