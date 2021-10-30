//
//  API.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.10.2021.
//

import Foundation
import SwiftSoup
public class API {
    
    
    public static func getDataValute() -> [Valute]  {
        var arrayValute : [Valute] = [Valute]()
        guard let url = URL(string: "https://www.banki.ru/products/currency/cb/") else {return arrayValute}
        do{
            let html = try String(contentsOf: url, encoding: .utf8)
            do {
                let doc = try SwiftSoup.parse(html)
                do {
                    let elementValute = try doc.select("td").array()
                    
                    let valueDOLLAR = Valute(nameValute: try elementValute[2].text(), countValute: try "$ \(elementValute[3].text())", changes: try elementValute[4].text(), ValuePlus: try elementValute[4].text().first == "+" ? true : false)
                    let valueEVRO = Valute(nameValute: try elementValute[7].text(), countValute:  try "€ \(elementValute[8].text())", changes: try elementValute[9].text(), ValuePlus: try elementValute[9].text().first == "+" ? true : false)
                    let valueYkraina = Valute(nameValute: try elementValute[137].text(), countValute:  try "₴ \(elementValute[138].text())", changes: try elementValute[139].text(), ValuePlus: try elementValute[139].text().first == "+" ? true : false )
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
}

public struct Valute {
    var nameValute : String
    var countValute : String
    var changes : String
    var ValuePlus : Bool
}
