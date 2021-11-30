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
    public var dataExchange : [Exchange] = []
    
    public var dataTableExchange : [Exchange] = []
    
    public var dataBitExchange : [Exchange] = []
}

public struct ValuteMainLabel {
    var nameValute : String
    var countValute : String
    var changes : String
    var ValuePlus : Bool
}

public struct OffersData {
    var title: String
    var backgroundImage: String
}

public struct Cards {
    var typeImageCard: String
    var typeMoney : String
    var nameCard : String
    var numberCard: String
    var moneyCount : String
    
    var cvv : String
    var data : Date
    var cardOperator : String
    var typeMoneyExtended : String
    
    var fullNumberCard: String
    var transactionID: String
    
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



