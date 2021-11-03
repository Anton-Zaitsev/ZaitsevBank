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
    @objc dynamic var family: String? = nil
    @objc dynamic var familyName: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var phone: String? = nil
    @objc dynamic var pol: String? = nil
    @objc dynamic var userID: String = ""
    public override static func primaryKey() -> String? {
        return "_id"
    }
}
