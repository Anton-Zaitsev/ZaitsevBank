//
//  NavigationController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.10.2021.
//

import UIKit
import LocalAuthentication
import CoreData

class NavigationController: UIViewController {
    
    private let authFaceID: AuthFromFaceID = AuthFromFaceID()
    
    private var pinCode = ""
    fileprivate let biometricsType: LABiometryType = {
        let laContext = LAContext()
        var error: NSError?
        let evaluated = laContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let laError = error {
            print("Ошибка при \(String(describing: error))")
            return .none
        }
        
        if #available(iOS 11.0, *) {
            if laContext.biometryType == .faceID { return .faceID }
            if laContext.biometryType == .touchID { return .touchID }
        } else {
            if (evaluated || (error?.code != LAError.touchIDNotAvailable.rawValue)) {
                return .touchID
            }
        }
        return .none
    }()
    
    lazy var ContainerLocalData: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZaitsevBank")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Не найден \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    @IBOutlet weak var LabelVersion: UILabel!
    
    @IBOutlet weak var Pass1: UIView!
    @IBOutlet weak var Pass2: UIView!
    @IBOutlet weak var Pass3: UIView!
    @IBOutlet weak var Pass4: UIView!
    @IBOutlet weak var Pass5: UIView!
    //Кнопки
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    @IBOutlet weak var Button0: UIButton!
    
    @IBOutlet weak var ButtonFaceTouchID: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(!UserDefaults.standard.isLogin()) {
            let AuthLogin = storyboard?.instantiateViewController(withIdentifier: "AuthStorybold") as! LoginController
            navigationController?.pushViewController(AuthLogin, animated: true)
        }
        else {
            GetView()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserDefaults.standard.isUsesFaceTouchID()) {
        signFromFaceID()
        }
    }
    
    
    fileprivate func GetView() {
        LabelVersion.text = "Версия: \(getVersionApp())"
        Pass1.layer.cornerRadius = 6
        Pass2.layer.cornerRadius = 6
        Pass3.layer.cornerRadius = 6
        Pass4.layer.cornerRadius = 6
        Pass5.layer.cornerRadius = 6
        
        switch(biometricsType.rawValue){
        case 2 :
            let imageFaceID = UIImage(systemName: "faceid")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.green)
            ButtonFaceTouchID.setImage(imageFaceID, for: .normal)
            break
        case 1 :
            let imageTouchID = UIImage(systemName: "touchid", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.red)
            ButtonFaceTouchID.setImage(imageTouchID, for: .normal)
            break
        case 0:
            let imageFaceID = UIImage(systemName: "faceid")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.red)
            ButtonFaceTouchID.setImage(imageFaceID, for: .normal)
            break
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func ClickButton1(_ sender: Any) {
        GetNumber(number: "1", Button1)
    }
    
    @IBAction func ClickButton2(_ sender: Any) {
        GetNumber(number: "2", Button2)
    }
    
    @IBAction func ClickButton3(_ sender: Any) {
        GetNumber(number: "3", Button3)
    }
    
    @IBAction func ClickButton4(_ sender: Any) {
        GetNumber(number: "4", Button4)
    }
    
    @IBAction func ClickButton5(_ sender: Any) {
        GetNumber(number: "5", Button5)
    }
    
    @IBAction func ClickButton6(_ sender: Any) {
        GetNumber(number: "6", Button6)
    }
    
    @IBAction func ClickButton7(_ sender: Any) {
        GetNumber(number: "7", Button7)
    }
    
    @IBAction func ClickButton8(_ sender: Any) {
        GetNumber(number: "8", Button8)
    }
    
    @IBAction func ClickButton9(_ sender: Any) {
        GetNumber(number: "9", Button9)
    }
    
    @IBAction func ClickButton0(_ sender: Any) {
        GetNumber(number: "0", Button0)
    }
    
    @IBAction func FaceID(_ sender: Any) {
        
        signFromFaceID()
    }
    
    @IBAction func DeleteButton(_ sender: Any) {
        switch(pinCode.count){
        case 1:
            Pass1.backgroundColor = .darkGray
            pinCode.remove(at: pinCode.index(before: pinCode.endIndex))
            break
        case 2:
            Pass2.backgroundColor = .darkGray
            pinCode.remove(at: pinCode.index(before: pinCode.endIndex))
            break
        case 3:
            Pass3.backgroundColor = .darkGray
            pinCode.remove(at: pinCode.index(before: pinCode.endIndex))
            break
        case 4:
            Pass4.backgroundColor = .darkGray
            pinCode.remove(at: pinCode.index(before: pinCode.endIndex))
            break
        case 5:
            Pass5.backgroundColor = .darkGray
            pinCode.remove(at: pinCode.index(before: pinCode.endIndex))
            break
        default:
            break
        }
    }
    
    fileprivate func signFromFaceID() {
        if (biometricsType.rawValue == 1 || biometricsType.rawValue == 2){
            authFaceID.signUSER(self, DatabaseLinkAutoLogin: ContainerLocalData)
        }
        else {
            authFaceID.getFaceIDorTouchID(self)
        }
    }
    
    private func GetNumber(number: String, _ button: UIButton){
        
        switch(pinCode.count){
        case 0:
            button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            Pass1.backgroundColor = .green
            pinCode += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 0
            }
            break
        case 1:
            button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            Pass2.backgroundColor = .green
            pinCode += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 0
            }
            break
        case 2:
            button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            Pass3.backgroundColor = .green
            pinCode += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 0
            }
            break
        case 3:
            button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            Pass4.backgroundColor = .green
            pinCode += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 0
            }
            break
        case 4:
            button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            Pass5.backgroundColor = .green
            pinCode += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 0
            }
            let loader = self.EnableLoader()
            authFaceID.signUserByPINCODE(self, DatabaseLinkAutoLogin: ContainerLocalData, PIN_CODE: pinCode,loader: loader)
            break
        default:
            break
        }
    }
    
    private func getVersionApp() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else {return appVersion}
        return "\(appVersion) (\(build))"
    }
}
