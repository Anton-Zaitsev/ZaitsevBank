//
//  MongoBankFunctionMore.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.03.2022.
//

import Foundation
import SwiftyJSON

public class MongoBankFunctionMore {
    
    public static func getNowData() async -> Date? {
        let valute = URL(string: "https://tools.aimylogic.com/api/now?tz=Europe/Moscow&format=dd/MM/yyyy")
        
        let request = URLRequest(url: valute!)
        
        do {
            let (dataValue,responce)  = try await URLSession.shared.data(for: request)
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else {
                print("Не скачалась дата для определения даты")
                return nil}
            if let optData = try? JSON(data: dataValue){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dataString = optData["formatted"].string ?? ""
                let date = dateFormatter.date(from: dataString) ?? nil
                return date
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

extension Date {
    func generateDataFromDB() -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = 4
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return futureDate!
    }
    func startOfMonth() -> Date {
           return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
       }
       
   func endOfMonth() -> Date {
       return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
   }
}

