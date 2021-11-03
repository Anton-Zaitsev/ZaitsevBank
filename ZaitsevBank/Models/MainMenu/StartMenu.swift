//
//  StartMenu.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 11.10.2021.
//

import Foundation

public class StartMenu {
    
    public let dataOffers : [OffersData] = [
        OffersData(title: "Как банк работает в выходные", backgroundImage: "timer" ),
        OffersData(title: "Заставки под микроскопом", backgroundImage: "iphone.homebutton.radiowaves.left.and.right" ),
        OffersData(title: "Все сервисы", backgroundImage: "chart.bar.doc.horizontal"),
        OffersData(title: "Перевод денег",backgroundImage: "person.crop.circle.fill.badge.checkmark")
    ]
    public let dataExchange : [Exchange] = [
        Exchange(typeValute: ValuteType.Dollar.rawValue, nameValute: "Доллар США", typeValuteExtended: "USD", buyValute: "73,55", chartBuy: true, saleValute: "69,88", chartSale: false),
        Exchange(typeValute: ValuteType.Evro.rawValue, nameValute: "Евро", typeValuteExtended: "EUR", buyValute: "84,33", chartBuy: false, saleValute: "81,35", chartSale: true)
    ]
}
public struct OffersData {
    var title: String
    var backgroundImage: String
}

public struct Cards {
    var typeImageCard: String
    var nameCard : String
    var numberCard: String
    var moneyCount : String
    var typeMoney : String
}

public struct Exchange {
    var typeValute: String
    var nameValute : String
    var typeValuteExtended : String
    var buyValute : String
    var chartBuy : Bool
    var saleValute: String
    var chartSale : Bool
}


public  enum ValuteType : String {
    case Dollar = "$", Evro = "€", Rub = "₽", BitCoin = "₿"
}

public enum TypeCardImage: String {
    case defaultCard
    case mirCard
    case sberCard
    
    var Value: String {
        switch self {
        case .defaultCard: return "SberCard"
        case .mirCard: return "MirCard"
        case .sberCard: return "SberCard"
        }
    }
}
