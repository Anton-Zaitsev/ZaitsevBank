//
//  API_DinamicValute.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 27.11.2021.
//

import Foundation
import SwiftSoup
import SWXMLHash
import SwiftyJSON

public class API_DinamicValute {
    
    public func GetDinamicValute(idValute: String,_ data: DataDinamicValute = .month) async -> DinamicValute? {
        
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = data.dataValute
        let lastDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        
        let date6MothBack = formatDate.string(from: lastDate!)
        let dateNow = formatDate.string(from: currentDate)
        
        
        let getDinamic = URL(string: "https://cbr.ru/scripts/XML_dynamic.asp?date_req1=\(date6MothBack)&date_req2=\(dateNow)&VAL_NM_RQ=\(idValute)")
        
        let request = URLRequest(url: getDinamic!)
        
        do {
            let (xmlDinamic,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return nil }
            
            var dinamic : DinamicValute = DinamicValute(value: [], data: [], min: 0, max: 0, start: 0, now: 0)
            
            let xml = XMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(xmlDinamic)
            
            
            for elem in xml["ValCurs"]["Record"].all {
                if let costValue = Double(elem["Value"].element!.text.replacingOccurrences(of: ",", with: ".")) {
                    if let data = elem.element?.attribute(by: "Date")?.text {
                        dinamic.value.append(costValue)
                        dinamic.data.append(data)
                    }
                }
            }
            if (dinamic.value.count > 0) {
                dinamic.start = dinamic.value.first ?? 0
                dinamic.min = dinamic.value.minOrZero()
                dinamic.max = dinamic.value.maxOrZero()
                dinamic.now = dinamic.value.last ?? 0
            }
            return dinamic
        }
        catch{
            return nil
        }
    }
    
    public func GetDinamicCriptoValute(nameValute: String,_ data: DataDinamicValute = .month) async -> DinamicValute? {
        
        let key = nameValute.lowercased().replacingOccurrences(of: " ", with: "-")
        let getDinamic = URL(string:"https://api.coincap.io/v2/assets/\(key)/history?interval=\(data.dataCriptoValute)")

        var request = URLRequest(url: getDinamic!)
        request.setValue("Bearer \(SettingApp.APICoinCap)", forHTTPHeaderField: "Authorization")
        request.setValue("gzip,deflate,br", forHTTPHeaderField: "Accept-Encoding")
        

        do{
            let (dataDinamicCripto,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return nil }
            
            if let json = try? JSON(data: dataDinamicCripto) {
            
                if (!json["data"].arrayValue.isEmpty) {
                    var dinamic : DinamicValute = DinamicValute(value: [], data: [], min: 0, max: 0, start: 0, now: 0)
                    
                    for data in json["data"].arrayValue {
                        if let valuteBuy = Double(data["priceUsd"].string ?? ""){
                            if var CurrentData = data["date"].string {
                                dinamic.value.append(valuteBuy)
                                
                                let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)", timeZone: .current)
                                
                                    for _ in 0..<5 {
                                        CurrentData.removeLast()
                                    }
                                    let date = try Date(CurrentData, strategy: strategy)
                                    let formatDate = DateFormatter()
                                    formatDate.dateFormat = "dd/MM/yyyy"
                                    let Date = formatDate.string(from: date)
                                    dinamic.data.append(Date)
                            }
                        }
                    }
                    if (dinamic.value.count > 0) {
                        dinamic.start = dinamic.value.first ?? 0
                        dinamic.min = dinamic.value.minOrZero()
                        dinamic.max = dinamic.value.maxOrZero()
                        dinamic.now = dinamic.value.last ?? 0
                    }
                    return dinamic
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        catch{
            return nil
        }
        
    }
    
    public func GetDinamicValuteFromDay(idValute: String) async -> [Double]? {
        
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -14
        let lastDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        
        let date7DayBack = formatDate.string(from: lastDate!)
        let dateNow = formatDate.string(from: currentDate)
        
        
        let getDinamic = URL(string: "https://cbr.ru/scripts/XML_dynamic.asp?date_req1=\(date7DayBack)&date_req2=\(dateNow)&VAL_NM_RQ=\(idValute)")
        
        let request = URLRequest(url: getDinamic!)
        
        do {
            let (xmlDinamic,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return nil }
            
            var dinamic : [Double] = [Double] ()
            
            let xml = XMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(xmlDinamic)
            
            
            for elem in xml["ValCurs"]["Record"].all {
                if let costValue = Double(elem["Value"].element!.text.replacingOccurrences(of: ",", with: "."))
                {
                    if let nominal = Double(elem["Nominal"].element!.text.replacingOccurrences(of: ",", with: ".")) {
                        
                        dinamic.append(costValue / nominal)
                    }
                }
            }
            return dinamic
        }
        catch{
            return nil
        }
    }
    
    public func GetDinamicCriptoValuteFromDay(nameValute: String) async -> [Double]? {
        
        let key = nameValute.lowercased().replacingOccurrences(of: " ", with: "-")
        let getDinamic = URL(string:"https://api.coincap.io/v2/assets/\(key)/history?interval=d1")

        var request = URLRequest(url: getDinamic!)
        request.setValue("Bearer \(SettingApp.APICoinCap)", forHTTPHeaderField: "Authorization")
        request.setValue("gzip,deflate,br", forHTTPHeaderField: "Accept-Encoding")


        do{
            let (dataDinamicCripto,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return nil }
            
            if let json = try? JSON(data: dataDinamicCripto) {
                
                if (!json["data"].arrayValue.isEmpty) {
                    var dinamic : [Double] = [Double]()
                    
                    for data in json["data"].arrayValue {
                        if let valuteBuy = Double(data["priceUsd"].string ?? ""){
                            dinamic.append(valuteBuy)
                        }
                    }
                    return dinamic
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        catch{
            return nil
        }
    }
       
}

public enum DataDinamicValute {
    case month
    case quarter
    case halfYear
    case year
    
    var dataValute: Int {
        switch self {
        case .month : return -1
        case .quarter : return -3
        case .halfYear : return -6
        case .year : return -12
        }
    }
    var dataCriptoValute: String {
        switch self {
        case .month : return "h1"
        case .quarter : return "h2"
        case .halfYear : return "h6"
        case .year : return "h12"
        }
    }
    var description : String {
        switch self {
        case .month : return "за месяц"
        case .quarter : return "за квартал"
        case .halfYear : return "за полгода"
        case .year : return "за год"
        }
    }
}
