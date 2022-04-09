//
//  CoreDataModel.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 12.10.2021.
//

import Foundation
import CoreData


@objc(AutoLoginSet)
public class AutoLoginSet: NSManagedObject {
    
}
extension AutoLoginSet {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AutoLoginSet> {
        return NSFetchRequest<AutoLoginSet>(entityName: "AutoLoginSet")
    }
    
    @NSManaged public var password: String?
    @NSManaged public var login: String?
    @NSManaged public var localPass: String?
    @NSManaged public var key: String?
    
}

extension AutoLoginSet : Identifiable {
    
}
