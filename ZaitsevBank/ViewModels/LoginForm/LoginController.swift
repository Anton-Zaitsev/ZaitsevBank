//
//  LoginController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 04.10.2021.
//

import UIKit
import RealmSwift
class LoginController: UIViewController {

    private var loginModel = LoginModel() //Объявляем модель данных для Login
    private let authFunc = AuthClient()
    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var SubMainLabel: UILabel!
    
    @IBOutlet weak var BorderFrameLogin: UIView!
    @IBOutlet weak var BorderFramePassword: UIView!
    @IBOutlet weak var LoginTextField: UITextField!
   
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
    }
    
    private func GetView() {
        MainLabel.numberOfLines = 0
        SubMainLabel.numberOfLines = 0
        BorderFrameLogin.layer.cornerRadius = 3
        BorderFramePassword.layer.cornerRadius = 3
        LoginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
       
        
    }
    
    @IBAction func SignClick(_ sender: Any){
        
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .medium) {
            let user = await authFunc.SignIn(login: loginModel.Login, pass: loginModel.Password)
            let boolRegistration = (user == nil ? false : true)
                DispatchQueue.main.async {
                if (boolRegistration){
                    let loader = self.EnableLoader()
                    self.DisableLoader(loader: loader)
                }
                else {
                    showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
                }
                
            }
            }
        }
    }
    
    @IBAction func LoginChanged(_ sender: Any) {
        loginModel.Login = LoginTextField.text ?? ""
        BorderFrameLogin.backgroundColor = CheckCorrectAuthData.checkLogin(login: loginModel.Login) ? UIColor.green : UIColor.red
    }

    
    @IBAction func PasswordChanged(_ sender: Any) {
        loginModel.Password = PasswordTextField.text ?? ""
        BorderFramePassword.backgroundColor = CheckCorrectAuthData.checkPassword(pass: loginModel.Password) ? UIColor.green : UIColor.red
    }
  
    @IBAction func TapClearKeyboard(_ sender: Any) {
        LoginTextField.resignFirstResponder()
        BorderFramePassword.resignFirstResponder()
    }
}


