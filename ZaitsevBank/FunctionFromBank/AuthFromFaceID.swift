//
//  AuthFromFaceID.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 21.10.2021.
//

import Foundation
import LocalAuthentication
import UIKit
import CoreData
public class AuthFromFaceID {
    
    private let authFunc = AuthClient()
    
    public func signUSER(_ viewController: NavigationController, DatabaseLinkAutoLogin: NSPersistentContainer, loader: UIView) {
        
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Пожалуйста введите ваш пароль"
        let reason = "Для продолжения вам требуется аутентификация"
        
        var authorizationError: NSError?
        
        
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            
            localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                if success {
                    UserDefaults.standard.SetisFaceTouchId(true) //Начать использование FaceID
                    
                    DispatchQueue.global(qos: .utility).async{ [self] in
                        Task(priority: .high) {
                            let userData: (String, String) = SafeLocalPassword.CheckDataLocal(database: DatabaseLinkAutoLogin)
                            let(login, password) = userData
                            
                            if (login == "none" || password == "none") {
                                DispatchQueue.main.async {
                                    viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось распознать логин или пароль.")
                                }
                                return
                            }
                            
                            DispatchQueue.main.async{
                                viewController.Pass1.backgroundColor = .green
                                viewController.Pass2.backgroundColor = .green
                                viewController.Pass3.backgroundColor = .green
                                viewController.Pass4.backgroundColor = .green
                                viewController.Pass5.backgroundColor = .green
                            }
                            
                            if let user = await authFunc.SignIn(login: login, pass: password) { // Если нашел такого пользователя
                                                                                                    
                                if let data = await GetDataUser().get(NoneUser: user) { // Если по нему есть какая-то информация
                                DispatchQueue.main.async{
                                    viewController.EnableMainLoader(NameUser: data.name!)
                                       
                                    let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                                    
                                    let NavigationTabBar = storyboardMainMenu.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
                                    
                                    NavigationTabBar.dataUser = data
                                        
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                        viewController.navigationController?.pushViewController(NavigationTabBar, animated: true)
                                    }
                                }
                                }
                                else {
                                    DispatchQueue.main.async{
                                        viewController.Pass1.backgroundColor = .darkGray
                                        viewController.Pass2.backgroundColor = .darkGray
                                        viewController.Pass3.backgroundColor = .darkGray
                                        viewController.Pass4.backgroundColor = .darkGray
                                        viewController.Pass5.backgroundColor = .darkGray
                                        viewController.DisableLoader(loader: loader)
                                        viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера")
                                    }
                                }
                            }
                            else {
                                DispatchQueue.main.async{
                                    viewController.Pass1.backgroundColor = .darkGray
                                    viewController.Pass2.backgroundColor = .darkGray
                                    viewController.Pass3.backgroundColor = .darkGray
                                    viewController.Pass4.backgroundColor = .darkGray
                                    viewController.Pass5.backgroundColor = .darkGray
                                    viewController.DisableLoader(loader: loader)
                                    viewController.showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
                                }
                            }
                            
                        }
                    }
                    
                }
                else {
                    viewController.DisableLoader(loader: loader)
                }
            }
        }
        else {
            viewController.DisableLoader(loader: loader)
            viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Биометрические данные не поддерживаются")
        }
    }
    
    public func signUserByPINCODE(_ viewController: NavigationController, DatabaseLinkAutoLogin: NSPersistentContainer, PIN_CODE: String, loader: UIView) {

        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                
                let userData: (String, String) =  SafeLocalPassword.CheckDataLocalFromPINCODE(PIN_CODE: PIN_CODE, database: DatabaseLinkAutoLogin)
                
                let(login, password) = userData
                
                if (login == "none" || password == "none"){
                    DispatchQueue.main.async {
                        viewController.DisableLoader(loader: loader)
                        viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не правильный PIN CODE")
                    }
                    return
                }
                
                DispatchQueue.main.async{
                    viewController.Pass1.backgroundColor = .green
                    viewController.Pass2.backgroundColor = .green
                    viewController.Pass3.backgroundColor = .green
                    viewController.Pass4.backgroundColor = .green
                    viewController.Pass5.backgroundColor = .green
                }
                
                if let user = await authFunc.SignIn(login: login, pass: password) {
                                 
                    if let data = await GetDataUser().get(NoneUser: user) {
                        
                        DispatchQueue.main.async {
                            viewController.DisableLoader(loader: loader)
                            viewController.EnableMainLoader(NameUser: data.name!)
                            
            
                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            
                            let NavigationTabBar = storyboardMainMenu.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
                            
                            NavigationTabBar.dataUser = data

                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                viewController.navigationController?.pushViewController(NavigationTabBar, animated: true)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            viewController.Pass1.backgroundColor = .darkGray
                            viewController.Pass2.backgroundColor = .darkGray
                            viewController.Pass3.backgroundColor = .darkGray
                            viewController.Pass4.backgroundColor = .darkGray
                            viewController.Pass5.backgroundColor = .darkGray
                            viewController.DisableLoader(loader: loader)
                            viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера")
                        }
                    }
                                
                }
                else {
                    DispatchQueue.main.async {
                        viewController.Pass1.backgroundColor = .darkGray
                        viewController.Pass2.backgroundColor = .darkGray
                        viewController.Pass3.backgroundColor = .darkGray
                        viewController.Pass4.backgroundColor = .darkGray
                        viewController.Pass5.backgroundColor = .darkGray
                        viewController.DisableLoader(loader: loader)
                        viewController.showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
                    }
                }
                
            }
        }
        
    }
    
    public func getFaceIDorTouchID(_ viewController: UIViewController) {
        
        let alertController = UIAlertController (title: "Разрешение на использование.", message: "Перейдите к настройкам и разрешите использовать FaceID или TouchID", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private func getErrorDescription(errorCode: Int) -> String {
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            return "Проверка подлинности не прошла успешно, поскольку пользователь не смог предоставить действительные учетные данные"
            
        case LAError.appCancel.rawValue:
            return "Аутентификация была отменена приложением."
            
        case LAError.invalidContext.rawValue:
            return "Не действительный вызов"
            
        case LAError.notInteractive.rawValue:
            return "Пользовательский интерфейс был запрещен для показа FACE ID"
            
        case LAError.passcodeNotSet.rawValue:
            return "Не удалось запустить аутентификацию, так как код доступа не установлен на устройстве"
            
        case LAError.systemCancel.rawValue:
            return "Аутефикация системы была отмененена, потому что другое приложение его уже использует"
            
        case LAError.userCancel.rawValue:
            return "Аутефикация была отменена пользователем"
            
        case LAError.userFallback.rawValue:
            return "Аутефикация отменена, пользователь не ввел пароль"
            
        default:
            return "Error code \(errorCode) not found"
        }
        
    }
    
    
}
