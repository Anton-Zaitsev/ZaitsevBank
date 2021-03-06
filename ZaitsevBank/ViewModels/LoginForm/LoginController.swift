//
//  LoginController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 04.10.2021.
//

import UIKit
import CoreData

class LoginController: UIViewController, LocalPasswordDelegate {
    
    private var loginModel = LoginModel() //Объявляем модель данных для Login
    private let authFunc = AccountManager()
    private var getNameUser : String = "USER"
    // LOCALPASSWORD
    public var LocalPasswordEncrypted: String = ""
    
    private lazy var ContainerLocalData: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZaitsevBank")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Не найден \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

    @IBOutlet weak var BorderFrameLogin: UIView!

    @IBOutlet weak var BorderFramePassword: UIView!
    
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(UserDefaults.standard.isLogin(), animated: animated)
    }
    
    private func GetView() {
        BorderFrameLogin.layer.cornerRadius = 3
        BorderFramePassword.layer.cornerRadius = 3
        LoginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        LoginTextField.delegate = self
        PasswordTextField.delegate = self
        setupVisualEffectView()
    }
    
    @IBAction func SignClick(_ sender: Any){
        
        LoginTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        let loader = EnableLoader()
        DispatchQueue.global(qos: .utility).async{ [self] in
            
            Task(priority: .high) {
                if let user = await authFunc.SignAccount(login: loginModel.Login, password: loginModel.Password){
                    
                    DispatchQueue.main.async { [self] in
                        getNameUser = user
                        DisableLoader(loader: loader)
                        SetAlertLocalPassword()
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        DisableLoader(loader: loader)
                        showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.Error)
                    }
                    return
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
        
    func SigninFromPassword() {
        animateOut()
        
        let succSafeLocalCode = SafeLocalPassword.AppSettingAppend(ContainerLocalData, localPassword: LocalPasswordEncrypted, login: loginModel.Login, password: loginModel.Password)
        
        if(succSafeLocalCode){
            
            EnableMainLoader(getNameUser)
            //MARK: Установка user на первоначальное вхождение и установка на true
            UserDefaults.standard.SetisLogin(true)

            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
            let NavigationTabBar = storyboardMainMenu.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.navigationController?.pushViewController(NavigationTabBar, animated: true)
            }
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось сохранить ваш локальный пароль")
        }
    }
    
    private func SetAlertLocalPassword() {
        view.addSubview(AlertLocalPassword)
        AlertLocalPassword.center = view.center
        animateIn()
    }
    
    private lazy var AlertLocalPassword: LocalPassword = {
        let alertLocalPassword: LocalPassword = LocalPassword.loadFromNib()
        alertLocalPassword.delegate = self
        return alertLocalPassword
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func animateIn() {
        AlertLocalPassword.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        AlertLocalPassword.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.AlertLocalPassword.alpha = 1
            self.AlertLocalPassword.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.4,
                       animations: {
            self.visualEffectView.alpha = 0
            self.AlertLocalPassword.alpha = 0
            self.AlertLocalPassword.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.AlertLocalPassword.removeFromSuperview()
        }
    }
    
}
extension LoginController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case LoginTextField :
            LoginTextField.resignFirstResponder()
            return true;
        case PasswordTextField :
            PasswordTextField.resignFirstResponder()
            return true;
        default:
            return true
        }
       
    }
}
