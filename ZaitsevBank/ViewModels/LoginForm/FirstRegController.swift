//
//  FirstRegController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 06.10.2021.
//

import UIKit

class FirstRegController: UIViewController {
    
    public var ModelRegistration = LoginModel()
    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var FrameName: UIView!
    @IBOutlet weak var FrameFamily: UIView!
    @IBOutlet weak var FrameFamilyName: UIView!
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var FamilyTextField: UITextField!
    @IBOutlet weak var FamilyNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false;
    }
    
    private func GetView() {
        MainLabel.text = "Ваши персональные\n данные"
        MainLabel.numberOfLines = 0
        
        NameTextField.attributedPlaceholder = NSAttributedString(string: "Ваше Имя",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        FamilyTextField.attributedPlaceholder = NSAttributedString(string: "Ваша фамилия",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        FamilyNameTextField.attributedPlaceholder = NSAttributedString(string: "Ваше отчество",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NameTextField.delegate = self
        FamilyTextField.delegate = self
        FamilyNameTextField.delegate = self
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height / 5
                navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @IBAction func NameChanged(_ sender: Any) {
        ModelRegistration.Name = NameTextField.text ?? ""
        FrameName.backgroundColor = ModelRegistration.Name.count > 2 ? .green : .red
    }
    @IBAction func FamilyChanged(_ sender: Any) {
        ModelRegistration.Family = FamilyTextField.text ?? ""
        FrameFamily.backgroundColor = ModelRegistration.Family.count > 2 ? .green : .red
    }
    @IBAction func FamilyNameChanged(_ sender: Any) {
        ModelRegistration.FamilyName = FamilyNameTextField.text ?? ""
        FrameFamilyName.backgroundColor = .green
    }
    @IBAction func ClickCheckDataUser(_ sender: Any) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        if (ModelRegistration.Name.count > 2 && ModelRegistration.Family.count > 2) {
            
            let LastRegView = storyboard?.instantiateViewController(withIdentifier: "LastRegistration") as! LastRegController
            LastRegView.ModelRegistration = ModelRegistration //Передаем данные
            navigationController?.pushViewController(LastRegView, animated: true)
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не верное имя или фамилия")
        }
    }
    
}
extension FirstRegController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.setNavigationBarHidden(false, animated: false)
        switch textField {
        case NameTextField :
            NameTextField.resignFirstResponder()
            return true;
        case FamilyTextField :
            FamilyTextField.resignFirstResponder()
            return true;
        case FamilyNameTextField :
            FamilyNameTextField.resignFirstResponder()
            return true;
        default:
            return true
        }
       
    }
}
