//
//  LastRegController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 08.10.2021.
//

import UIKit
import CoreData

class LastRegController: UIViewController, LocalPasswordDelegate {
    
    @IBOutlet weak var MainLabel: UILabel!
    
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var BirthTextField: UITextField!
    @IBOutlet weak var PolTextField: UITextField!
    
    @IBOutlet weak var FramePhone: UIView!
    @IBOutlet weak var FrameDatePicker: UIView!
    @IBOutlet weak var FramePol: UIView!
    
    private let datePicker = UIDatePicker()
    private var pickerPol = UIPickerView()
    
    private let Pol = ["Мужчина", "Женщина", "Не определился"]
    
    public var ModelRegistration = LoginModel()
    private let authFunc = AccountManager()
    
    lazy var ContainerLocalData: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZaitsevBank")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Не найден \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
    }
    
    private func GetView() {
        MainLabel.text = "Последний шаг\n к новому аккаунту"
        MainLabel.numberOfLines = 0
        
        PhoneTextField.attributedPlaceholder = NSAttributedString(string: "Ваш номер телефона",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        BirthTextField.attributedPlaceholder = NSAttributedString(string: "Ваша дата рождения",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        PolTextField.attributedPlaceholder = NSAttributedString(string: "Ваш пол",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        CreateDatePicker()
        pickerPol.delegate = self
        pickerPol.dataSource = self;
        PolTextField.inputView = pickerPol
        setupVisualEffectView()
    }
    
    @IBAction func PhoneChanged(_ sender: Any) {
        PhoneTextField.text = CheckCorrectAuthData.formattedPhone(number: PhoneTextField.text ?? "")
        ModelRegistration.Phone = PhoneTextField.text ?? ""
        FramePhone.backgroundColor = ModelRegistration.Phone.count == 15 ? .green : .red
    }
    
    @IBAction func DateChanged(_ sender: Any) {
        BirthTextField.text = ModelRegistration.Year
        FrameDatePicker.backgroundColor = ModelRegistration.Year.count == 10 ? .green : .red
    }
    
    @IBAction func PolChanged(_ sender: Any) {
        PolTextField.text = ModelRegistration.Pol
        FramePol.backgroundColor = Pol.contains(ModelRegistration.Pol) ? .green : .red
    }
    
    private var DataUser: UserModel!
    
    @IBAction func CreateNewAccount(_ sender: Any) {
        if (FramePhone.backgroundColor == .green) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if ((dateFormatter.date(from:ModelRegistration.Year)) != nil) {
                
                if (Pol.contains(ModelRegistration.Pol)) {
                    //Регистрация нового аккаунта
                    self.navigationController?.setNavigationBarHidden(true, animated: true) //disable navigationBar
                    
                    DispatchQueue.main.async {
                        let loader = self.EnableLoader()
                        DispatchQueue.global(qos: .utility).async{ [self] in
                            Task(priority: .high) {
                                if let user = await authFunc.CreateAccount(model: ModelRegistration) {
                                    DispatchQueue.main.async { [self] in
                                        DataUser = user
                                        DisableLoader(loader: loader)
                                        SetAlertLocalPassword()
                                    }
                                }
                                else {
                                    DispatchQueue.main.async { [self] in
                                        DisableLoader(loader: loader)
                                        showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.Error)
                                        navigationController?.setNavigationBarHidden(false, animated: true) //Enable navigationBar
                                    }
                                }
                                
                                
                            }
                        }
                    }
                    
                }
                else {
                    showAlert(withTitle: "Произошла ошибка", withMessage: "Не верный выбранный пол")
                }
            }
            else {
                showAlert(withTitle: "Произошла ошибка", withMessage: "Не верная дата рождения")
            }
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не верный номер телефона")
        }
    }
    
    private func CreateDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneCliced))
        toolbar.setItems([doneButton], animated: true)
        
        BirthTextField.inputAccessoryView = toolbar
        BirthTextField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc private func doneCliced () {
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd.MM.yyyy"
        BirthTextField.text = formatDate.string(from: datePicker.date)
        ModelRegistration.Year = formatDate.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    //LOCALPASSWORD
    
    func SigninFromPassword() {
        animateOut()
        
        let succSafeLocalCode =  SafeLocalPassword.AppSettingAppend(ContainerLocalData, localPassword: LocalPasswordEncrypted, login: ModelRegistration.Login, password: ModelRegistration.Password)
        
        if(succSafeLocalCode){
            //MARK: Установка user на первоначальное вхождение и установка на true
            UserDefaults.standard.SetisLogin(true)
            
            self.EnableMainLoader(ModelRegistration.Name)
            //SafeLocalPassword.ReadDataLocal(database: ContainerLocalData)
            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
            
            let NavigationTabBar = storyboardMainMenu.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigationController?.pushViewController(NavigationTabBar, animated: true)
            }
            
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось сохранить ваш локальный пароль")
        }
    }
    
    var LocalPasswordEncrypted: String = ""
    
    func SetAlertLocalPassword() {
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

extension LastRegController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Pol.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Pol[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PolTextField.text = Pol[row]
        ModelRegistration.Pol = Pol[row]
        PolTextField.resignFirstResponder()
    }
}
