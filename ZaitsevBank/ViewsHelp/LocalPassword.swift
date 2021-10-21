//
//  LocalPassword.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.10.2021.
//

import UIKit

protocol LocalPasswordDelegate: AnyObject {
    func SigninFromPassword()
    var LocalPasswordEncrypted: String { get set }
}

class LocalPassword: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var SuperView: UIView!
    
    @IBOutlet weak var TextFieldPass: UITextField!
    
    @IBOutlet weak var Pass1: UIView!
    
    @IBOutlet weak var Pass2: UIView!
    
    @IBOutlet weak var Pass3: UIView!
    
    @IBOutlet weak var Pass4: UIView!
    
    @IBOutlet weak var Pass5: UIView!
    
    weak var delegate: LocalPasswordDelegate?
    
    @IBAction func PasswordChanged(_ sender: Any) {
        let count = TextFieldPass.text?.count
        
        switch count {
        case 0:
            Pass1.backgroundColor = #colorLiteral(red: 0.5778313875, green: 0.5778453946, blue: 0.5778378248, alpha: 1)
        case 1:
            Pass1.backgroundColor = .green
            Pass2.backgroundColor = #colorLiteral(red: 0.5778313875, green: 0.5778453946, blue: 0.5778378248, alpha: 1)
        case 2:
            Pass2.backgroundColor = .green
            Pass3.backgroundColor = #colorLiteral(red: 0.5778313875, green: 0.5778453946, blue: 0.5778378248, alpha: 1)
        case 3:
            Pass3.backgroundColor = .green
            Pass4.backgroundColor = #colorLiteral(red: 0.5778313875, green: 0.5778453946, blue: 0.5778378248, alpha: 1)
        case 4:
            Pass4.backgroundColor = .green
            Pass5.backgroundColor = #colorLiteral(red: 0.5778313875, green: 0.5778453946, blue: 0.5778378248, alpha: 1)
        case 5:
            Pass5.backgroundColor = .green
            delegate?.LocalPasswordEncrypted = TextFieldPass.text!
            TextFieldPass.resignFirstResponder()
            delegate?.SigninFromPassword()
        case .none:
            return
        case .some(_):
            return
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        SuperView.layer.cornerRadius = 15
        Pass1.layer.cornerRadius = 10
        Pass2.layer.cornerRadius = 10
        Pass3.layer.cornerRadius = 10
        Pass4.layer.cornerRadius = 10
        Pass5.layer.cornerRadius = 10
        TextFieldPass.delegate = self
        TextFieldPass.isHidden = true
        TextFieldPass.becomeFirstResponder()
    }
    
    @objc(textField:shouldChangeCharactersInRange:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_LENGTH = 5
        let updatedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return updatedString.count <= MAX_LENGTH
    }
    
}
