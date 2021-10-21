//
//  RegistrationController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 05.10.2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    public var ModelRegistration = LoginModel()
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var StartNavigationItem: UINavigationItem!
    
    @IBOutlet weak var BorderFrameLogin: UIView!
    
    @IBOutlet weak var BorderFramePassword: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
    }
    
    private func GetView() {
        StartNavigationItem.titleView?.tintColor = .white
        
        LoginTextField.attributedPlaceholder = NSAttributedString(string: "Ваша почта",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Придумайте пароль",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    
    @IBAction func ClickGoCheck(_ sender: Any) {
        if (CheckCorrectAuthData.checkLogin(login: ModelRegistration.Login)){
            
            if (CheckCorrectAuthData.checkPassword(pass:ModelRegistration.Password)){
                let FirstRegView = storyboard?.instantiateViewController(withIdentifier: "FirstRegistration") as! FirstRegController
                FirstRegView.ModelRegistration = ModelRegistration //Передаем данные
                navigationController?.pushViewController(FirstRegView, animated: true)
            }
            else {
                showAlert(withTitle: "Произошла ошибка", withMessage: "Длинна пароля должна быть больше 6")
            }
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не правильный логин")
        }
    }
    
    
    
    @IBAction func LoginChanged(_ sender: Any) {
        ModelRegistration.Login = LoginTextField.text ?? ""
        BorderFrameLogin.backgroundColor = CheckCorrectAuthData.checkLogin(login: ModelRegistration.Login) ? .green : .red
    }
    
    
    @IBAction func PasswordChanged(_ sender: Any) {
        ModelRegistration.Password = PasswordTextField.text ?? ""
        BorderFramePassword.backgroundColor = CheckCorrectAuthData.checkPassword(pass: ModelRegistration.Password) ? .green : .red
    }
    
    @IBAction func TapClearKeyboard(_ sender: Any) {
        LoginTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
}
