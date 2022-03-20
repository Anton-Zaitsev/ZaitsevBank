//
//  AuthClien.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 04.10.2021.
//

import Foundation
import RealmSwift

public class AuthClient {
        
    public var ErrorAuthClient: String = ""
    
    
    private func AuthUser (login: String, pass : String) async throws -> User{
        let client = RealmSettings.getApp()
        let loggedInUser = try await client.login(credentials: Credentials.emailPassword(email: login, password: pass.sha256()))
        return loggedInUser
        
    }
    
    public func SignIn(login: String, pass: String) async -> User? {
        if (CheckCorrectAuthData.checkAuth(login: login, pass: pass)){
            do {
                let user = try await AuthUser(login: login, pass: pass)
                return user
            } catch {
                ErrorAuthClient = "Ошибка входа в аккаунт: \(error.localizedDescription)"
                return nil
            }
        }
        else {
            ErrorAuthClient = "Не правильный логин или пароль"
            return nil
        }
    }
    
    public func Registration(dataUser: LoginModel) async -> User?{
        if (CheckCorrectAuthData.checkAuth(login: dataUser.Login, pass: dataUser.Password)) {
            let client = RealmSettings.getApp().emailPasswordAuth
            do {
                try await client.registerUser(email: dataUser.Login, password: dataUser.Password.sha256())
                
                if let USER = await SignIn(login: dataUser.Login, pass: dataUser.Password) {
                //Получение пользователя
                    let configuration = USER.configuration(partitionValue: RealmSettings.getAuthIDClient())
                    let realm = try await Realm(configuration: configuration)
                    
                    try realm.write {
                        let clientModel = clientZaitsevBank()
                        clientModel.authID = RealmSettings.getAuthIDClient()
                        clientModel.name = dataUser.Name
                        clientModel.family = dataUser.Family
                        clientModel.familyName = dataUser.FamilyName
                        clientModel.phone =  "+7 \(dataUser.Phone)"
                        clientModel.birthday = dataUser.Year
                        clientModel.pol = dataUser.Pol
                        clientModel.userID = USER.id
                        clientModel.avatar = ""
                        realm.add(clientModel)
                    }
                    
                    return USER
                }
                else {
                    ErrorAuthClient = "Ошибка при регистрации: Пользователя не удалось создать."
                    return nil
                }

            } catch {
                ErrorAuthClient = "Ошибка при регистрации: \(error.localizedDescription)"
                return nil
            }
        }
        else {
            ErrorAuthClient = "Не правильный логин или пароль"
            return nil
        }
    }
    
    private func DeleteUser (user: User) {
        user.remove()  { (error) in
            self.ErrorAuthClient = "Ошибка клиента"
        }
    }
}

