//
//  ClientObjects.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.10.2021.
//

import Foundation
import RealmSwift


public class clientZaitsevBank: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var authID: String = ""
    @Persisted var avatar: String? = nil
    @Persisted var birthday: String? = nil
    @Persisted var family: String? = nil
    @Persisted var familyName: String? = nil
    @Persisted var name: String? = nil
    @Persisted var phone: String? = nil
    @Persisted var pol: String? = nil
    @Persisted var userID: String = ""
}
