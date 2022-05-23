//
//  AllTransactionsOperation.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.05.2022.
//

import Foundation

public enum AllTransactionsOperation: Int {
    case IncomingTransfer = 0 // Входящий перевод
    case OutgoingTransfer = 1 // Исходящий перевод
    case TakeCredit = 2// Взять кредит
    case PaymentCredit = 3// Оплата кредита
    case RepaymentCredit = 4// Погащение кредита
    case CurrencyTransfer = 5 // Перевод валюты
    case PaymentServices = 6 // Оплата услуг
    case ActivationCard = 7 // Активация карты
    case DeActivationCard = 8 // Деактивация карты по сроку
    case BetweenMyCards = 9 //Между своими счетами
    case ReturnMoney = 10 //Возврат средств
    case IncomingTransferAndCurrencyTransfer = 11 //Входящий перевод с переводом валюты
    case OutgoingTransferAndCurrencyTransfer = 12 //Исходящий перевод с переводом валюты
    case BetweenMyCardsAndCurrencyTransfer = 13 //Между своими счетами с переводом валюты
    case PaymentServicesAndCurrencyTransfer = 14 //Оплата услуг с переводом валюты
}
