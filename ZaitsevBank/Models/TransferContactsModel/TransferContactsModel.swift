//
//  TransferContactsModel.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 15.05.2022.
//

import Foundation
import UIKit

public struct TransferContactsModel {
    public var SectionModel: String
    public var Contacts : [ContactsModel]
}
public struct ContactsModel {
    public var ImageContact: UIImage?
    public var NameContact: String
    public var FamilyContact: String
    public var PhoneNumber: String
}
public enum TransferZaitsevType {
    case Contacts
    case Cards
}
