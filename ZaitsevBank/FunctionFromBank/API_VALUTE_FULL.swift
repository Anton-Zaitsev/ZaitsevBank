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
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetExchangeList(ElectronValute: false))
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return dataCB }
            
            if let json = try? JSON(data: dataValue) {
                
                await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
                    
                    for (_,subJson):(String, JSON) in json {
                        taskGroup.addTask {
                            let downloadedDinamic = await self.getDinamicParalles(subJson,valuteElectron: false)
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
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: ClienZaitsevBankAPI.getRequestGetExchangeList(ElectronValute: true))
            
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                return dataCB }
            
            if let json = try? JSON(data: dataValue){
                
                await withTaskGroup(of: ExchangeFull?.self) { taskGroup in
                    
                    for (_,subJson):(String, JSON) in json {
                        taskGroup.addTask {
                            let downloadedDinamic = await self.getDinamicParalles(subJson,valuteElectron: true)
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
    
    private func getDinamicParalles(_ data: JSON,valuteElectron: Bool) async -> ExchangeFull?  {
        
        let idValute = data["idValute"].stringValue
        guard let dataChart = valuteElectron ? await api.GetDinamicCriptoValuteFromDay(nameValute: idValute) : await api.GetDinamicValuteFromDay(idValute: idValute) else {
            return nil
        }
        return ExchangeFull(IDValute: idValute, charCode: data["charCode"].stringValue, nameValute: data["nameValute"].stringValue, changesBuy: data["changesBuy"].boolValue, buy: data["valuteBuy"].doubleValue.valuteToTableFormat(), changesSale: data["changesSale"].boolValue, sale: data["valuteSale"].doubleValue.valuteToTableFormat(), dataChar: dataChart)
    }
}
