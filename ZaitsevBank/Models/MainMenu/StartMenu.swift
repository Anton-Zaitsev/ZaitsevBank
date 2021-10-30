//
//  StartMenu.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 11.10.2021.
//

import Foundation

public class StartMenu {
    public var dataUser : clientZaitsevBank!
    
    public let dataOffers : [OffersData] = [
        OffersData(title: "Как банк работает в выходные", backgroundImage: "timer" ),
        OffersData(title: "Заставки под микроскопом", backgroundImage: "iphone.homebutton.radiowaves.left.and.right" ),
        OffersData(title: "Все сервисы", backgroundImage: "chart.bar.doc.horizontal"),
        OffersData(title: "Перевод денег",backgroundImage: "person.crop.circle.fill.badge.checkmark")
    ]
    
    
}
public struct OffersData {
    var title: String
    var backgroundImage: String
}
