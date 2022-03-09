//
//  ParametrsAddCardViewController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.11.2021.
//

import UIKit

class ParametrsAddCardViewController: UIViewController {
        
    @IBOutlet weak var LabelTypeValute: UITextField!
    @IBOutlet weak var ViewLabelTypeValute: UIView!
    @IBOutlet weak var LabelPickValute: UILabel!
    
    
    private var pickerValute = UIPickerView()
    
    private let NewCardAdd = RegistrationNewCard()
    
    private let ValutePicker = ["Рубли", "Доллары", "Евро","Биткоин", "Эфириум"]
    
    private let ValuteLabel = ["В рублях ₽", "В долларах $", "В евро €","В биткойне Ƀ", "В эфириуме ◊"]
    
    private let ValuteDB = ["RUB", "USD", "EUR","BTC", "ETH"]
    
    private let ValutePickLabel = ["₽", "$", "€","Ƀ", "◊"]
    
    
    private let generateCard = CardGenerator()
    
    public var CARDDATA : CardAddStructData!
    
    public var ValutePick : String?
    
    private var CVVNUMBER : String = ""
    
    @IBOutlet weak var FrontCardView: UIView!
    @IBOutlet weak var BackCardView: UIView!
    
    
    //FRONT BANK CARD
    
    @IBOutlet weak var TypeSIM: UIImageView!
    
    @IBOutlet weak var ViewDataCard: UIStackView!
    
    @IBOutlet weak var OwnerCard: UILabel!
    
    @IBOutlet weak var TypeCard: UILabel!
    
    @IBOutlet weak var CardNumber: UILabel!
    
    //
    
    
    //BACK BANK CARD
    
    @IBOutlet weak var TermCard: UILabel!
    
    @IBOutlet weak var CVVLABEL: UILabel!
    
    @IBOutlet weak var TypeCardBack: UIImageView!
    
    
    //
    
    @IBOutlet weak var LabelOwnerCard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetView()
        // Do any additional setup after loading the view.
    }
    
    private func GetView() {
        
        LabelPickValute.text = "Выберете валюту\nнажав на круг:"
        
        if let valutePick = ValutePick{
            let indexes = ValuteDB.enumerated().filter {
                $0.element.contains(valutePick)
            }.map{$0.offset}
            if (!indexes.isEmpty){
                LabelTypeValute.text = ValutePickLabel[indexes.first!]
                LabelPickValute.text = "Валюта вашей карты:\n" + ValuteLabel[indexes.first!]
            }
        }
        
        self.setNavigationBar("Параметры карты")
        
        ViewLabelTypeValute.layer.cornerRadius = ViewLabelTypeValute.frame.height / 2
        
        LabelOwnerCard.text = CARDDATA.nameFamily
        //SETTINGS FRONT CARD
        TypeCard.text = CARDDATA.typeCard.uppercased()
        
        if (CARDDATA.newDesign){
            ViewDataCard.isHidden = true
            OwnerCard.isHidden = true
        }
        else {
            if (CARDDATA.typeSIM == "defaultCardSIM"){
                TypeSIM.layer.cornerRadius = 10
                TypeSIM.backgroundColor = .white
            }
            TypeSIM.image = UIImage(named: CARDDATA.typeSIM)
            OwnerCard.text = CARDDATA.nameFamily.uppercased()
        }
        CardNumber.text = generateCard.generateNumberCar(typeCard: CARDDATA.typeCard)
        //
        
        //SETTINGS BACK CARD
        CVVNUMBER = generateCard.generateCVV()
        TermCard.text = "До \(generateCard.generateData())"
        CVVLABEL.text = "Код \(CVVNUMBER)"
        TypeCardBack.image = UIImage(named: generateCard.logoTypeCard(CARDDATA.typeCard))
        //
        
        LabelTypeValute.delegate = self
        LabelTypeValute.tintColor = .clear
        pickerValute.delegate = self
        pickerValute.dataSource = self;
        LabelTypeValute.inputView = pickerValute
        
        
        FrontCardView.layer.cornerRadius = 15
        BackCardView.layer.cornerRadius = 15
        
        BackCardView.isHidden = true
        
        
        FrontCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        FrontCardView.isUserInteractionEnabled = true
        BackCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        BackCardView.isUserInteractionEnabled = true
    }
    
    
    @objc private func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tag = gestureRecognizer.view?.tag
        switch tag! {
        case 0 :
            BackCardView.showFlip()
            FrontCardView.hideFlip()
        case 1 :
            BackCardView.hideFlip()
            FrontCardView.showFlip()
        default:
            print("default")
        }
    }
    
    @IBAction func RegistrNewCard(_ sender: Any) {
        if ValutePickLabel.contains(LabelTypeValute.text!) {
            
            let loader = self.EnableLoader()
            
            DispatchQueue.global(qos: .utility).async{ [self] in
                Task(priority: .high) {
                    
                    let numberCar = CardNumber.text!.replacingOccurrences(of: "  ", with: " ")
                    
                    
                    let typeMoney = ValutePick ?? ValuteDB.first
                    
                    let typeCar = generateIcon(type: CARDDATA.typeCard)
                    
                    let succAddNewCard = await NewCardAdd.newCard(cardOperator: CARDDATA.typeCard, typeCard: typeCar, nameCard: CARDDATA.typeLabelCard, numberCard: numberCar, typeMoney: typeMoney!, CVV: CVVNUMBER)
                    
                    if (succAddNewCard) {
                        
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            let NavigationMain = storyboard?.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
                            self.navigationController?.pushViewController(NavigationMain, animated: true)
                            
                        }
                    }
                    else {
                        self.DisableLoader(loader: loader)
                        showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось зарегистрировать новую карту.")
                    }
                }
            }
            
        }
        else {
            LabelPickValute.textColor = .red
            LabelTypeValute.textColor = .black
            ViewLabelTypeValute.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.ViewLabelTypeValute.backgroundColor = .orange
                self.LabelTypeValute.textColor = .white
                self.LabelPickValute.textColor = .white
            }
        }
    }
    
    private func generateIcon(type: String) -> String {
        switch type {
        case "VISA" : return "SberCard"
        case "MASTERCARD" : return "SberCard"
        case "MIR" : return "MirCard"
        default:
            return "SberCard"
        }
    }
}

extension ParametrsAddCardViewController : UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ValutePicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ValutePicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ValutePick = ValuteDB[row]
        LabelTypeValute.text = ValutePickLabel[row]
        LabelPickValute.text = "Валюта вашей карты:\n" + ValuteLabel[row]
        LabelTypeValute.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = true
    }
}
