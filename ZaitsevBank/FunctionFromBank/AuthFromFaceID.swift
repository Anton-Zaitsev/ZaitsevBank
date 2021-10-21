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
    
    public func signUSER(_ viewController: UIViewController, DatabaseLinkAutoLogin: NSPersistentContainer) {
        
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Пожалуйста введите ваш пароль"
        let reason = "Для продолжения вам требуется аутентификация"
        
        var authorizationError: NSError?
        
        
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            
            localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                if success {
                    
                    DispatchQueue.global(qos: .utility).async{ [self] in
                        Task(priority: .high) {
                            let userData: (String, String) = SafeLocalPassword.CheckDataLocal(database: DatabaseLinkAutoLogin)
                            let(login, password) = userData
                            
                            let user = await authFunc.SignIn(login: login, pass: password)
                            let boolRegistration = (user == nil ? false : true)
                            
                            DispatchQueue.main.async {
                                if (boolRegistration){
                                    
                                    Task(priority: .high) {
                                        
                                        if let data = await GetDataUser().get(NoneUser: user) {
                                            
                                            viewController.EnableMainLoader(NameUser: data.name!)
                                            
                                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                                            let StartMain = storyboardMainMenu.instantiateViewController(withIdentifier: "StartMainMenu") as! StartMainController
                                            StartMain.dataUser = data
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                                viewController.navigationController?.pushViewController(StartMain, animated: true)
                                            }
                                            
                                        }
                                        else {
                                            viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера")
                                        }
                                    }
                                }
                                else {
                                    viewController.showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
                                }
                            }
                            
                        }
                    }
                    
                } else {
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        viewController.showAlert(withTitle: "Произошла ошибка", withMessage: messageToDisplay)
                    }
                }
            }
        }
        else {
            viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Биометрические данные не поддерживаются")
        }
    }
    
    public func signUserByPINCODE(_ viewController: UIViewController, DatabaseLinkAutoLogin: NSPersistentContainer, PIN_CODE: String) {

        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                let userData: (String, String) =  SafeLocalPassword.CheckDataLocalFromPINCODE(PIN_CODE: PIN_CODE, database: DatabaseLinkAutoLogin)
                let(login, password) = userData
                
                if (login == "" || password == ""){
                    DispatchQueue.main.async {
                        viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не правильный PIN CODE")
                    }
                }
                else {
                let user = await authFunc.SignIn(login: login, pass: password)
                let boolRegistration = (user == nil ? false : true)
                
                    DispatchQueue.main.async {
                        if (boolRegistration){
                            
                            Task(priority: .high) {
                                
                                if let data = await GetDataUser().get(NoneUser: user) {
                                    
                                    viewController.EnableMainLoader(NameUser: data.name!)
                                    
                                    let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                                    let StartMain = storyboardMainMenu.instantiateViewController(withIdentifier: "StartMainMenu") as! StartMainController
                                    StartMain.dataUser = data
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                        viewController.navigationController?.pushViewController(StartMain, animated: true)
                                    }
                                    
                                }
                                else {
                                    viewController.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера")
                                }
                            }
                        }
                        else {
                            viewController.showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
                        }
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
