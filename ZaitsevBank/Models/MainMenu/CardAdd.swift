//
//  CardAdd.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.11.2021.
//

import Foundation


public class CardAddModel {
    
    public var dataCard: [CardAddStructData] = []
    
    init(nameFamily: String) {
        
        let OwnerNameFamily = transliterate(nonLatin: nameFamily).uppercased()
        
        var data1 : [CardAddPerformance] = []
        
        data1.append(CardAddPerformance(image: "bahtsign.circle", mainLabel: "Повышенный процент", label: "В категории на выбор"))
        data1.append(CardAddPerformance(image: "cart.circle", mainLabel: "Обслуживание 0 ₽", label: "От любых покупок"))
        data1.append(CardAddPerformance(image: "creditcard.and.123", mainLabel: "Бонусные программы", label: "Дополнительные проценты при покупки крипты"))
        
        dataCard.append(CardAddStructData(nameFamily: OwnerNameFamily, typeSIM: "goldCardSIM", newDesign: false, typeBank: "ZAITSEV BANK", typeCard: "VISA", typeLabelCard: "Молодежная ZaitsevКарта", typeBuyCard: "Бесплатно в течении 3 месяцев", dataCard: data1))
        
        var data2 : [CardAddPerformance] = []
        
        data2.append(CardAddPerformance(image: "bahtsign.circle", mainLabel: "140000 бонусов", label: "Можете накопить за год при покупка BIT"))
        data2.append(CardAddPerformance(image: "cart.circle", mainLabel: "Обслуживание 0 ₽", label: "При 100 удачных продаж биткойна"))
        data2.append(CardAddPerformance(image: "creditcard.and.123", mainLabel: "Снятие наличных без комиссии", label: "Можете посмотреть как это сделать в главном меню"))
        
        dataCard.append(CardAddStructData(nameFamily: OwnerNameFamily, typeSIM: "defaultCardSIM", newDesign: false, typeBank: "ZAITSEV BANK", typeCard: "МИР", typeLabelCard: "CryptoZaitsevКарта", typeBuyCard: "Бесплатно при получении", dataCard: data2))
        
        var data3 : [CardAddPerformance] = []
        
        data3.append(CardAddPerformance(image: "bahtsign.circle", mainLabel: "120000 бонусов", label: "Можете накопить за 2 года при покупка BIT"))
        data3.append(CardAddPerformance(image: "cart.circle", mainLabel: "Обслуживание 0 ₽", label: "При покупке от 5000 ₽ в месяц"))
        data3.append(CardAddPerformance(image: "creditcard.and.123", mainLabel: "До следующего месяца", label: "Обслуживание 0 ₽ и 5 % бонусов"))
        
        dataCard.append(CardAddStructData(nameFamily: "", typeSIM: "", newDesign: true, typeBank: "СБЕР БАНК", typeCard: "MASTERCARD", typeLabelCard: "Цифровая СберКарта", typeBuyCard: "Бесплатно при покупках от 5000 ₽", dataCard: data3))
    }
    
    fileprivate func transliterate(nonLatin: String) -> String {
        let mut = NSMutableString(string: nonLatin) as CFMutableString
        CFStringTransform(mut, nil, "Any-Latin; Latin-ASCII; Any-Lower;" as CFString, false)
        return (mut as String)
    }
}


public struct CardAddStructData {
    var nameFamily : String
    var typeSIM : String
    var newDesign : Bool
    var typeBank : String
    var typeCard : String
    
    var typeLabelCard : String
    var typeBuyCard : String
    
    var dataCard : [CardAddPerformance]
}

public struct CardAddPerformance{
    var image : String
    var mainLabel: String
    var label: String
}
