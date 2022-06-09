//
//  AccountManager.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.04.2022.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

public class AccountManager {
    
    public var Error = "Не удалось выполнить запрос"
    
    public func CreateAccount(model: LoginModel) async -> String? {
        
        let request = ClienZaitsevBankAPI.getRequestCreateAccount(model: model)
        
        do {
            let (user,responce)  = try await URLSession.shared.data(for: request)
            if let code = (responce as? HTTPURLResponse)?.statusCode {
                
                if let requestResult =  RequestResult.init(rawValue: code){
                    switch requestResult{
                    case .OK :
                        if let json = try? JSON(data: user){
                            let userID = json["userID"].stringValue
                            let nameUser = json["nameUser"].stringValue
                            UserDefaults.standard.SetisUserID(userID)
                            return nameUser
                        }
                        else {
                            return nil
                        }
                    case .NotFound:
                        Error = "Пользователь не найден"
                        return nil
                    case .EthernalServer:
                        Error = "Сервер временно не доступен"
                        return nil
                    case .NotCreate:
                        Error = "Не удалось создать пользователя"
                        return nil
                    case .BadRequest:
                        Error = "Не удалось выполнить ваш запрос"
                        return nil
                    }
                }
                else { return nil}
                
            } else {return nil }
        }
        catch { return nil }
    }
    
    public func SignAccount(login: String,password: String) async -> String? {
        let request = ClienZaitsevBankAPI.getRequestSignAccount(login: login, password: password)
        
        do {
            let (user,responce)  = try await URLSession.shared.data(for: request)
            if let code = (responce as? HTTPURLResponse)?.statusCode {
                if let requestResult =  RequestResult.init(rawValue: code){
                    switch requestResult{
                    case .OK :
                        if let json = try? JSON(data: user){
                            let userID = json["userID"].stringValue
                            let nameUser = json["nameUser"].stringValue
                            UserDefaults.standard.SetisUserID(userID)
                            return nameUser
                        }
                        else {
                            return nil
                        }
                    case .NotFound:
                        Error = "Пользователь не найден"
                        return nil
                    case .EthernalServer:
                        Error = "Сервер временно не доступен"
                        return nil
                    case .NotCreate:
                        Error = "Не верный email"
                        return nil
                    case .BadRequest:
                        Error = "Не удалось выполнить ваш запрос"
                        return nil
                    }
                }
                else { return nil}
                
            } else {return nil }
        }
        catch { return nil }
    }
    
    public func GetUserData () async -> UserModel? {
        if (UserDefaults.standard.checkUserID()) {
            let userID = UserDefaults.standard.isUserID()
            
            let request = ClienZaitsevBankAPI.getRequestGetUserData(userID: userID)
            do {
                let (user,responce)  = try await URLSession.shared.data(for: request)
                guard (responce as? HTTPURLResponse)?.statusCode == RequestResult.OK.rawValue else {
                    return nil }
                let decoder = JSONDecoder()
                let Account = try decoder.decode(UserModel.self, from: user)
                return Account
            }
            catch {
                return nil
            }
        }
        else {return nil}
    }
    
    public func ExitUser () {
        let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.ContainerLocalData.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AutoLoginSet")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let arrUsrObj = try managedContext.fetch(fetchRequest)
            for usrObj in arrUsrObj as! [NSManagedObject] {
                managedContext.delete(usrObj)
            }
           try managedContext.save() //don't forget
        } catch _ as NSError { }
    }
}
