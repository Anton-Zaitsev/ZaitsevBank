//
//  LastRegController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 08.10.2021.
//

import UIKit

class LastRegController: UIViewController {
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
    private let authFunc = AuthClient()
    
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
    

    @IBAction func CreateNewAccount(_ sender: Any) {
        if (FramePhone.backgroundColor == .green) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if ((dateFormatter.date(from:ModelRegistration.Year)) != nil) {
                
                if (Pol.contains(ModelRegistration.Pol)) {
                    //Регистрация нового аккаунта
                    DispatchQueue.global(qos: .utility).async{ [self] in
                        Task(priority: .medium) {
                        let user = await authFunc.Registration(dataUser: ModelRegistration)
                        let boolRegistration = (user == nil ? false : true)
                        DispatchQueue.main.async {
                            if (boolRegistration){
                                showAlert(withTitle: "Поздравляем!", withMessage: "Вы успешно зарегестрированы")
                            }
                            else {
                                showAlert(withTitle: "Произошла ошибка", withMessage: authFunc.ErrorAuthClient)
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
