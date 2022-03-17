//
//  ValuteStructures.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 07.11.2021.
//

import Foundation

public enum BitcoinValutyType: String {
    case BTC
    case ETH
    case BNB
    case SOL
    case USDT
    case ADA
    case XRP
    case DOT
    case DOGE
    case USDC
    
    static let allValues = [BTC, ETH, BNB, SOL, USDT, ADA, XRP, DOT, DOGE ,USDC]
        
    var description: String {
        switch self {
        case .BTC : return "Биткоин"
        case .ETH : return "Эфириум"
        case .BNB : return "Binance Coin"
        case .SOL : return "Solana"
        case .USDT : return "Tether"
        case .ADA : return "Cardano"
        case .XRP : return "XRP"
        case .DOT : return "Polkadot"
        case .DOGE : return "Dogecoin"
        case .USDC : return "USD Coin"
        }
    }
}

public enum ValuteZaitsevBank : String {
    case EUR
    case USD
    case RUB
    case BTC
    case ETH
        
    var description: String {
        switch self {
        case .EUR : return "€"
        case .USD : return "$"
        case .RUB : return "₽"
        case .BTC : return "Ƀ"
        case .ETH : return "◊"
        }
    }
    
    var descriptionTypeValute: String {
        switch self {
        case .EUR : return "Карта в евро"
        case .USD : return "Карта в долларах"
        case .RUB : return "Карта в рублях"
        case .BTC : return "Карта в биткойне"
        case .ETH : return "Карта в эфириуме"
        }
    }
    
    var electronValute : Bool {
        switch self{
        case .RUB : return false
        case .EUR : return false
        case .USD : return false
        case .BTC : return true
        case .ETH : return true
        }
    }
}

public enum ValuteType : String {
    case AUD
    case AZN
    case GBP
    case AMD
    case BYN
    case BGN
    case BRL
    case HUF
    case HKD
    case DKK
    case USD
    case EUR
    case INR
    case KZT
    case CAD
    case KGS
    case CNY
    case MDL
    case NOK
    case PLN
    case RON
    case XDR
    case SGD
    case TJS
    case TRY
    case TMT
    case UZS
    case UAH
    case CZK
    case SEK
    case CHF
    case ZAR
    case KRW
    case JPY
    
    var description: String {
        switch self {
        case .AUD: return   "$"
        case .AZN : return  "₼"
        case .GBP : return  "£"
        case .AMD : return  "֏"
        case .BYN : return  "₽"
        case .BGN : return  "€"
        case .BRL : return  "$"
        case .HUF : return  "HUF"
        case .HKD : return  "$"
        case .DKK : return  "D"
        case .USD : return  "$"
        case .EUR : return  "€"
        case .INR : return  "₨"
        case .KZT : return  "Т"
        case .CAD : return  "$"
        case .KGS : return  "C"
        case .CNY : return  "元"
        case .MDL : return  "L"
        case .NOK : return  "NOK"
        case .PLN : return  "zł"
        case .RON : return  "RON"
        case .XDR : return  "XDR"
        case .SGD : return  "$"
        case .TJS : return  "TJS"
        case .TRY : return  "L"
        case .TMT : return  "TMT"
        case .UZS : return  "UZS"
        case .UAH : return  "₴"
        case .CZK : return  "K"
        case .SEK : return  "KR"
        case .CHF : return  "₣"
        case .ZAR : return  "ZAR"
        case .KRW : return  "Ŵ"
        case .JPY : return  "¥"
        }
    }
    

}
