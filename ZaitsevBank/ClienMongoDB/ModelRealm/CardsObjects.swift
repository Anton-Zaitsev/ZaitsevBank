//
//  CardsObjects.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 30.10.2021.
//

import Foundation
import RealmSwift

public class clientCardsCredit: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var authID: String = ""
    let card = RealmSwift.List<clientCardsCredit_card>()
    @objc dynamic var userID: String = ""
    override public static func primaryKey() -> String? {
        return "_id"
    }
}

public class clientCardsCredit_card: EmbeddedObject {
    @objc dynamic var cardOperator: String? = nil
    @objc dynamic var cvvv: String? = nil
    @objc dynamic var data: Date? = nil
    let moneyCount = RealmProperty<Double?>()
    @objc dynamic var nameCard: String? = nil
    @objc dynamic var numberCard: String? = nil
    @objc dynamic var transactionID: String? = nil
    @objc dynamic var typeCard: String? = nil
    @objc dynamic var typeMoney: String? = nil
    @objc dynamic var typeMoneyExtended: String? = nil
}

