//
//  ClientObjects.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.10.2021.
//

import Foundation
import RealmSwift


public class clientZaitsevBank: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var authID: String = ""
    @objc dynamic var avatar: String? = nil
    @objc dynamic var birthday: String? = nil
    @objc dynamic var cards: clientZaitsevBank_cards?
    @objc dynamic var family: String? = nil
    @objc dynamic var familyName: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var phone: String? = nil
    @objc dynamic var pol: String? = nil
    @objc dynamic var userID: String? = nil
    public override static func primaryKey() -> String? {
        return "_id"
    }
}

public class clientZaitsevBank_cards: EmbeddedObject {
    @objc dynamic var CCV: String? = nil
    @objc dynamic var cardId: String? = nil
    @objc dynamic var idChip: String? = nil
    @objc dynamic var numberCard: String? = nil
    @objc dynamic var serviceProvider: String? = nil
    @objc dynamic var term: String? = nil
    @objc dynamic var typeCard: String? = nil
}
