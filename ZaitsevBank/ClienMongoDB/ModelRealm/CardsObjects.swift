//
//  CardsObjects.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 30.10.2021.
//

import Foundation
import RealmSwift

public class clientCardsCredit: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var authID: String = ""
    @Persisted var card: List<clientCardsCredit_card>
}

public class clientCardsCredit_card: EmbeddedObject {
    @Persisted var cardOperator: String? = nil
    @Persisted var closed: Bool? = nil
    @Persisted var cvvv: String? = nil
    @Persisted var data: Date? = nil
    @Persisted var moneyCount: Double? = nil
    @Persisted var nameCard: String? = nil
    @Persisted var numberCard: String? = nil
    @Persisted var transactionID: String? = nil
    @Persisted var typeCard: String? = nil
    @Persisted var typeMoneyExtended: String? = nil
}


