//
//  AllTransactions.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.05.2022.
//

import Foundation

public struct SortedAllTransaction {
    public var date: String = ""
    public var allTransactions : [AllTransactions] = []
}
public class AllTransactions : Codable
  {
    public var typeTransaction : Int // Тип транзакции
    public var nameTransaction: String  // Название транзакции
    public var dateTime: Date  // Время транзакции
    public var transactionId: String // ID транзакции

    public var transactionValuteBetween: TransactionValuteBetween?  // Между своими счетами и перевод валюты

    public var transactionCardOrCredit : TransactionCardOrCredit?  // Активация карты или кредита, а так же его закрытие

    public var transactionPaymentServices: TransactionPaymentServices?  // Оплата товаров или услуг // Для исходящих и выходящих переводов

    public var transactionCredit: TransactionCredit?  // Погащения кредита
  }

  public class TransactionValuteBetween: Codable // Между своими счетами и перевод валюты
  {
      public var fromCardName : String  // Название карты из которой произошла транзакция денег
      public var toCardName: String  // Карта куда пришли деньги

      // Внизу могут быть nil, потому что может быть транзакция на перевод валюту, тогда они не нужны
      public var countValute: Double?

      public var valuteType : String? // Так же может быть опущен, так как на транзакцию перевода валюты он не играет роли
      public var transactionValute: TransactionValute?
  }

  public class TransactionValute : Codable// Перевод валюты
  {
      public var buySale: Bool // true покупка и false продажа
      public var valuteA : String  // Из валюты А
      public var valuteB : String // В валюту B

      public var countValuteA : Double
      public var countValuteB: Double
  }

  public class TransactionCardOrCredit: Codable
  {
      public var name: String

      public var activation: Bool // true Если Успешно активирована, false если заблокирована
  }

  public class TransactionPaymentServices: Codable // Оплата товаров или услуг и перевод валюты
  {
      public var nameClient : String

      public var countMoney: Double

      public var valuteType: String

      public var transactionValute : TransactionValute?

  }

  public class TransactionCredit: Codable
  {
      public var numberDocument : String

      public var countMoney: Double

      public var progress: Float 
  }

