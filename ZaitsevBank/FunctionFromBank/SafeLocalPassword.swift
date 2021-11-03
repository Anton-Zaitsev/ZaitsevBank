//
//  SafeLocalPassword.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 11.10.2021.
//

import Foundation
import CoreData

public class SafeLocalPassword {
    
    
    public static func FeatchCountData(database: NSPersistentContainer) -> Bool {
        
        let context: NSManagedObjectContext = {
            return database.viewContext
        }()
        let fetchRequest: NSFetchRequest<AutoLoginSet> = AutoLoginSet.fetchRequest()
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.count > 0
            
        }
        catch {
            return false
        }
        
    }
    
    public static func CheckDataLocal(database: NSPersistentContainer) -> (String, String) {
        
        let context: NSManagedObjectContext = {
            return database.viewContext
        }()
        let fetchRequest: NSFetchRequest<AutoLoginSet> = AutoLoginSet.fetchRequest()
        do {
            let objects = try context.fetch(fetchRequest)
            let dataModel = objects.first
            let login = try! dataModel?.login?.decryptMessage(encryptionKey: (dataModel?.key)!) ?? "none"
            let password = try! dataModel?.password?.decryptMessage(encryptionKey: (dataModel?.key)!) ?? "none"
            return  (login,password)
            
        }
        catch {
            return ("","")
        }
        
    }
    
    public static func CheckDataLocalFromPINCODE(PIN_CODE: String ,database: NSPersistentContainer) -> (String, String) {
        
        
        let context: NSManagedObjectContext = {
            return database.viewContext
        }()
        
        let fetchRequest: NSFetchRequest<AutoLoginSet> = AutoLoginSet.fetchRequest()
        do {
            let objects = try context.fetch(fetchRequest)
            
            let dataModel = objects.first
                       
            let pincode = try! dataModel?.localPass?.decryptMessage(encryptionKey: (dataModel?.key)!) ?? "none"

            if (PIN_CODE == pincode){
                
                let login = try! dataModel?.login?.decryptMessage(encryptionKey: (dataModel?.key)!) ?? "none"
                let password = try! dataModel?.password?.decryptMessage(encryptionKey: (dataModel?.key)!) ?? "none"
                return  (login,password)
            }
            else {
                return ("","")
            }
            
        }
        catch {
            return ("","")
        }
        
    }
    
    
    public static func AppSettingAppend(_ database: NSPersistentContainer, localPassword: String, login: String, password: String ) -> Bool {
        
        let context: NSManagedObjectContext = {
            return database.viewContext
        }()
        
        let fetchRequest: NSFetchRequest<AutoLoginSet> = AutoLoginSet.fetchRequest()
        do {
            var objects = try context.fetch(fetchRequest)
            objects.removeAll()
        }
        catch{
            print("Не найдено объекты для выбранной базы")
        }
        
        let dataApp = AutoLoginSet(context: context)
        
        let newAPPID = UUID()
        
        do {
            let key = try Ecryption.generateEncryptionKey(withPassword: newAPPID.uuidString)
            
            dataApp.appID = newAPPID
            dataApp.localPass = try localPassword.encryptMessage(encryptionKey: key)
            dataApp.login = try login.encryptMessage(encryptionKey: key)
            dataApp.password = try password.encryptMessage(encryptionKey: key)
            dataApp.key = key
            
            if context.hasChanges {
                do {
                    try context.save()
                    return true
                } catch {
                    context.rollback()
                    let nserror = error as NSError
                    print("Произошла ошибка \(nserror), \(nserror.userInfo)")
                    return false
                }
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
}



