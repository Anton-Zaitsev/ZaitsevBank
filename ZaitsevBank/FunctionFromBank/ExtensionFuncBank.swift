//
//  ExtensionFuncBank.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation

public extension Int {

    init?(doubleVal: Double) {
        guard (doubleVal <= Double(Int.max).nextDown) && (doubleVal >= Double(Int.min).nextUp) else {
        return nil
    }

    self.init(doubleVal)
}
}
    
public extension Double {
     func valuteToTableFormat() -> String {
         if let converted = Int(exactly: self) {
             return String(converted)
         }
         else {
             let valute = String(format: "%.2f", self)
             return valute.replacingOccurrences(of: ".", with: ",")
         }
    }
    func valuteToCurseFormat() -> String {
        if let converted = Int(exactly: self) {
            return String(converted)
        }
        else {
            let valute = String(format: "%.5f", self)
            return valute.replacingOccurrences(of: ".", with: ",")
        }
    }
    func maxNumber(CountMax: Int) -> Bool {
        
        if self == Double(Int(self)) {
            let integerString = String(Int(self))
            return integerString.count <= 9
        }
        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1
        return decimalCount <= CountMax
    }
}

public extension String {
    func convertToDouble(valutePay: String) -> (Double,String)? {
        let formatText = String(self.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  ",", with: ".")
        
        if let summToInt = Int(formatText){
            let summToIntToDouble = Double(summToInt)
            if (summToIntToDouble.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: valutePay)!.CountMaxDouble)){
                
                let fmt = NumberFormatter()
                fmt.numberStyle = .decimal
                fmt.locale = Locale(identifier: "fr_FR")
                return (summToIntToDouble, fmt.string(for: summToInt)! )
            }
            else {
                return nil
            }
        }
        else {
            if let summ = Double (formatText) {
                if (summ.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: valutePay)!.CountMaxDouble)){
                    return (summ,formatText.replacingOccurrences(of:  ".", with: ","))
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
    func convertDouble() -> Double? {
        let formatText = String(self.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  ",", with: ".")
        
        if let summToInt = Int(formatText){
            let summToIntToDouble = Double(summToInt)
            return summToIntToDouble
        }
        else {
            if let summ = Double (formatText) {
                return summ
            }
            else {
                return nil
            }
        }
    }
    func formatCardNumber() -> String {
        let mask = "XXXX XXXX XXXX XXXX"
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    func searchOperatorCard() -> String {
        let symbol = Int(self)
        switch symbol{
            case 4:
                return CardType.VISA.logoCardOperator
            case 5:
                return CardType.MASTERCARD.logoCardOperator
            case 2:
                return CardType.MIR.logoCardOperator
        default:
            return "LogoZaitsevBank"
        }
    }
    func searchLogoWalletCard() -> String {
        switch self {
        case "MIR": return "MirCard"
        default: return "SberCard"
        }
    }
}

