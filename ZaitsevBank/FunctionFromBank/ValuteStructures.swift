//
//  ValuteStructures.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 07.11.2021.
//

import Foundation


struct ValuteCb: Codable {
    let date, previousDate: Date
    let previousURL: String
    let timestamp: Date
    let valute: [String: Valute]

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

// MARK: - Valute
struct Valute: Codable {
    let id, numCode, charCode: String
    let nominal: Int
    let name: String
    let value, previous: Double

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}

struct BitcoinTableFullData: Codable  {
    let data: [BitcoinTableData]
    let timestamp: Int
    

}
struct BitcoinTableData: Codable  {
    let id, rank, symbol, name ,supply, maxSupply, marketCapUsd, volumeUsd24Hr,priceUsd, changePercent24Hr, vwap24Hr,explorer : String?
}

struct BitcoinChartTable: Codable {
    let data: [BitcoinChartTableData]
    let timestamp: Int
}

struct BitcoinChartTableData: Codable {
    let priceUsd: String
    let time: Int
    let circulatingSupply, date: String
}

struct BitcoinValutes: Codable {
    let ticker: Ticker
    let timestamp: Int
    let success: Bool
    let error: String
}

// MARK: - Ticker
struct Ticker: Codable {
    let base, target, price, volume: String
    let change: String
}


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
    
    static let allValuesFromTable = [BTC, ETH, BNB]
    
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
