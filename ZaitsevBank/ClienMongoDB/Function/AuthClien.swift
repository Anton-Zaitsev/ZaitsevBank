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
                var user =  await SignIn(login: dataUser.Login, pass: dataUser.Password)
                //Получение пользователя
             
                let configuration = user!.configuration(partitionValue: RealmSettings.getAuthIDClient())
                
                Realm.asyncOpen(configuration: configuration) { [self] (result) in
                        switch result {
                        case .failure(let error):
                            ErrorAuthClient = "Ошибка при регистрации: \(error.localizedDescription)"
                            DeleteUser(user: user!)
                            user = nil
                        case .success(let realm):
                            let tasks = realm.objects(clientZaitsevBank.self)
                            
                            let notificationToken = tasks.observe { (changes) in
                                    switch changes {
                                    case .initial: break
                                    case .update(_, _, _, _):
                                        break
                                    case .error(let error):
                                        ErrorAuthClient = "Ошибка при регистрации: \(error.localizedDescription)"
                                        DeleteUser(user: user!)
                                        user = nil
                                    }
                                }
                            
                            try! realm.write() {
                                let clientModel = clientZaitsevBank()
                                clientModel.authID = RealmSettings.getAuthIDClient()
                                clientModel.name = dataUser.Name
                                clientModel.family = dataUser.Family
                                clientModel.familyName = dataUser.FamilyName
                                clientModel.phone =  "+7 \(dataUser.Phone)"
                                clientModel.birthday = dataUser.Year
                                clientModel.pol = dataUser.Pol
                                clientModel.userID = (user?.id.sha256())!
                                clientModel.avatar = ""
                                realm.add(clientModel)
                            }
                            
                            
                            notificationToken.invalidate()
                        }
                    }

                return user
                
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
