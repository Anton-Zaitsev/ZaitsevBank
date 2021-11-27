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
        
        guard let dataValue = await getData(url: valute!) else {
            print("Не скачалась дата")
            return dataCB }
        
        do {
            
            let json = try newJSONDecoder().decode(ValuteCb.self, from: dataValue)
            for data in json.valute {
                let value = data.value
                
                let valuteBuy = value.value / Double(value.nominal)
                let valuteSale = valuteBuy + Double.random(in: -3..<3)
                
                let valuteBuy300 = valuteBuy + Double.random(in: -0.5..<(-0.1))
                let valuteBuy1000 = valuteBuy300 + Double.random(in: -0.5..<(-0.1))
                let valuteBuy5000 = valuteBuy1000 + Double.random(in: -1..<(-0.3))
                
                let valuteSale300 = valuteSale + Double.random(in: -0.5..<(-0.1))
                let valuteSale1000 = valuteSale300 + Double.random(in: -0.5..<(-0.1))
                let valuteSale5000 = valuteSale1000 + Double.random(in: -1..<(-0.3))
                
                dataCB.append(ExchangeFull(IDValute: value.id, charCode: value.charCode, nameValute: value.name, changesBuy: value.value > value.previous, buy: valuteBuy.valuteToTableFormat(), buy300: valuteBuy300.valuteToTableFormat(), buy1000: valuteBuy1000.valuteToTableFormat(), buy5000: valuteBuy5000.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), sale300: valuteSale300.valuteToTableFormat(), sale1000: valuteSale1000.valuteToTableFormat(), sale5000: valuteSale5000.valuteToTableFormat()))
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
        
        guard let dataValue = await getData(url: valute!) else {
            print("Не скачалась дата")
            return dataCB }
        
        do {
            
            let json = try newJSONDecoder().decode(ValuteCb.self, from: dataValue)
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
        
        
        // FULL API https://api.cryptonator.com/api/full/DOGE-usd
        
        
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
            
            let json = try newJSONDecoder().decode(BitcoinTableFullData.self, from: dataValue)
            
            for bit in json.data {
                if let valuteBuy = Double(bit.priceUsd!){
                    if let changes = Double(bit.changePercent24Hr!){
                        
                        let valuteSale = valuteBuy + Double.random(in: -3..<3)
                        
                        let valuteBuy300 = valuteBuy + Double.random(in: -0.5..<(-0.1))
                        let valuteBuy1000 = valuteBuy300 + Double.random(in: -0.5..<(-0.1))
                        let valuteBuy5000 = valuteBuy1000 + Double.random(in: -1..<(-0.3))
                        
                        let valuteSale300 = valuteSale + Double.random(in: -0.5..<(-0.1))
                        let valuteSale1000 = valuteSale300 + Double.random(in: -0.5..<(-0.1))
                        let valuteSale5000 = valuteSale1000 + Double.random(in: -1..<(-0.3))
                        
                        dataCB.append(ExchangeFull(IDValute: bit.id!, charCode: bit.symbol!, nameValute: bit.name!, changesBuy: changes > 0, buy: valuteBuy.valuteToTableFormat(), buy300: valuteBuy300.valuteToTableFormat(), buy1000: valuteBuy1000.valuteToTableFormat(), buy5000: valuteBuy5000.valuteToTableFormat(), changesSale: Bool.random(), sale: valuteSale.valuteToTableFormat(), sale300: valuteSale300.valuteToTableFormat(), sale1000: valuteSale1000.valuteToTableFormat(), sale5000: valuteSale5000.valuteToTableFormat()))
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
    
    public static func GetDinamicValute(idValute: String) async -> DinamicValute? {
        
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = -6
        let lastDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        
        let date6MothBack = formatDate.string(from: lastDate!)
        let dateNow = formatDate.string(from: currentDate)
        
        
        let getDinamic = URL(string: "https://cbr.ru/scripts/XML_dynamic.asp?date_req1=\(date6MothBack)&date_req2=\(dateNow)&VAL_NM_RQ=\(idValute)")
        
        guard let xmlDinamic = await getData(url: getDinamic!) else {
            print("Не скачалась дата")
            return nil }
        var dinamic : DinamicValute = DinamicValute(value: [], data: [], min: 0, max: 0, start: 0, now: 0)
        
        let xml = XMLHash.config {
            config in
            config.shouldProcessLazily = true
        }.parse(xmlDinamic)
        
        
        for elem in  xml["ValCurs"]["Record"].all {
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
    
    public static func GetDinamicCriptoValute(nameValute: String) async -> DinamicValute? {
        
        let key = nameValute.lowercased().replacingOccurrences(of: " ", with: "-")
        let getDinamic = URL(string:"https://api.coincap.io/v2/assets/\(key)/history?interval=h6")
        
        var request = URLRequest(url: getDinamic!)
        request.setValue("Bearer \(SettingApp.APICoinCap)", forHTTPHeaderField: "Authorization")
        request.setValue("gzip,deflate,br", forHTTPHeaderField: "Accept-Encoding")
        

        do{
            let (dataDinamicCripto,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата")
                return nil }
            let json = try newJSONDecoder().decode(BitcoinChartTable.self, from: dataDinamicCripto)
            
            if (!json.data.isEmpty) {
                var dinamic : DinamicValute = DinamicValute(value: [], data: [], min: 0, max: 0, start: 0, now: 0)
                
                for data in json.data {
                    if let valuteBuy = Double(data.priceUsd){
                        dinamic.value.append(valuteBuy)
                        
                        let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)", timeZone: .current)
                        var CurrentData = data.date
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
        catch{
            return nil
        }
        
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

fileprivate extension Double {
    func valuteToTableFormat() -> String {
        let valute = String(format: "%.2f", self)
        return valute.replacingOccurrences(of: ".", with: ",")
    }
}


