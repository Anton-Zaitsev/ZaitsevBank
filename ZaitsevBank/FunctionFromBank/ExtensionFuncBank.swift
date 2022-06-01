//
//  ExtensionFuncBank.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.12.2021.
//

import Foundation


extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

public extension Double {
    func convertedToMoneyValute(valute: ValuteZaitsevBank) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale(identifier: "fr_FR")
        let convert = fmt.string(from: self as NSNumber)
        
        return convert ?? (valute.electronValute ? self.valuteToCurseFormat() : self.valuteToTableFormat())
    }
    
    func convertedToMoney() -> String {
        let roundingString = String(format: "%.2f", self)
        let roundedDouble = Double(roundingString)!
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale(identifier: "fr_FR")
        return fmt.string(from: roundedDouble as NSNumber) ?? roundedDouble.valuteToTableFormat()
    }
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
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formatPhoneTextField() -> String {
        let cleanPhoneNumber = self.replacingOccurrences(of: "+7", with: "").components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+7 (###) ###-##-##"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
        
    }
    
    func formatCardTextField() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "#### #### #### ####"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
        
    }
    
    func formatPhone() -> String {
        
        var phoneReplaced = String(self.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  "(", with: "").replacingOccurrences(of:  ")", with: "").replacingOccurrences(of:  "-", with: "").replacingOccurrences(of:  "+", with: "")
        
        if (phoneReplaced.count > 10){ // На тот случай, если это номер с индефикатором страны, else будет выполняться почти всегда
            phoneReplaced.removeFirst()
        }
        phoneReplaced = "7" + phoneReplaced
        
        let mask = "+X (XXX) XXX-XX-XX"
        let numbers = phoneReplaced.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
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

