//
//  CardsObjects.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 30.10.2021.
//

import Foundation
import RealmSwift

public class clientCardsCredits: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var authID: String = ""
    let card = List<clientCardsCredits_card>()
    @objc dynamic var userID: String = ""
    public override static func primaryKey() -> String? {
        return "_id"
    }
}
public class clientCardsCredits_card: EmbeddedObject {
    @objc dynamic var cvvv: String? = nil
    @objc dynamic var data: String? = nil
    let moneyCount = RealmProperty<Double?>()
    @objc dynamic var nameCard: String? = nil
    @objc dynamic var numberCard: String? = nil
    @objc dynamic var typeCard: String? = nil
    @objc dynamic var typeMoney: String? = nil
}
