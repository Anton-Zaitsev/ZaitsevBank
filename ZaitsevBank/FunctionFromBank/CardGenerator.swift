//
//  CardGenerator.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 14.11.2021.
//

import Foundation

class CardGenerator {

    public func generateNumberCar(typeCard: String) -> String{
        var cardNumber = ""
        
        switch typeCard{
        case CardType.VISA.description:
            cardNumber += "4"
            break
        case CardType.MASTERCARD.description:
            cardNumber += "5"
            break
        case CardType.MIR.description:
            cardNumber += "2"
            break
        default:
            cardNumber += "0"
            break
        }
        for index in 1..<16 {
            if(index % 4 == 0){
                cardNumber += "  "
            }
            let randomInt = Int.random(in: 0..<9)
            cardNumber += "\(randomInt)"
        }
        return cardNumber
    }
    
    public func generateCVV() -> String {
        let countCVV = 3
        var CVV = ""
        for _ in 0..<countCVV {
            let randomInt = Int.random(in: 0..<9)
            CVV += "\(randomInt)"
        }
        return CVV
    }
    
    
    public func generateData() -> String {
        let currentDate = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "MM/yy"
        return formatDate.string(from: currentDate.generateDataFromDB())
    }
    

    public func generateTransactionID(NumberCard: String) -> String {
        let replaced = NumberCard.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return replaced.sha256()
    }
    
    
    public func logoTypeCard (_ typeCard: String) -> String {
            switch typeCard {
            case "VISA":
                return "visaLogo"
            case "MASTERCARD":
                return "masterCardLogo"
            case "МИР":
                return "mirLogo"
                
            default:
                return "mirLogo"
            }
    }
}

public enum CardType: String {
    case VISA
    case MASTERCARD
    case MIR
    
    static let allValues = [VISA, MASTERCARD, MIR]
        
    
    var description: String {
        switch self {
        case .VISA : return "VISA"
        case .MASTERCARD : return "MASTERCARD"
        case .MIR : return "MIR"
        }
    }
    
    var logoCardOperator: String {
        switch self {
        case .VISA : return "visaLogo"
        case .MASTERCARD : return "masterCardLogo"
        case .MIR : return "mirLogo"
        }
    }
    
}

