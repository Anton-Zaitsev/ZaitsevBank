//
//  CreditOfferController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 27.05.2022.
//

import UIKit

class CreditOfferController: UIViewController,CardPickDelegate {
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        if let cards = Cards {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                Task(priority: .high) {
                    
                    if await self.transactionManager.ApplyCredit(summ: self.summCredit!, year: self.yearCredit, transactionCard: cards[indexPickCard!].transactionID) {
                        DispatchQueue.main.async { [self] in
                            
                            let storyboard = UIStoryboard(name: "TransferMenu", bundle: nil)
                            let transactionTemplate = storyboard.instantiateViewController(withIdentifier: "TransactionTemplate") as! TransactionTemplateController
                            transactionTemplate.operationName = "Оформление кредита"
                            transactionTemplate.operationTitle = "\(summCredit!.valuteToTableFormat()) \(valuteRub.description)"
                            transactionTemplate.operationSubTitle = "Кредит успешно оформлен на \(yearCredit * 12) месяцев"
                            navigationController?.pushViewController(transactionTemplate, animated: true)
                            
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось оформить кредит")
                        }
                    }
                    
                }
            }
        }
        else {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                Task(priority: .medium) {
                    
                    if let data = await AccountManager().GetUserData(){
                        DispatchQueue.main.async {
                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                            AddNewCardController.nameFamilyOwner = "\(data.firstName) \(data.lastName)"

                            AddNewCardController.ValutePick = self.valuteRub.rawValue 
                            self.DisableLoader(loader: loader)
                            self.navigationController?.pushViewController(AddNewCardController, animated: true)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о пользователе")
                        }
                    }
                    
                }
            }
        }
    }
    

    @IBOutlet weak var CreditSum: UITextField!
    
    @IBOutlet weak var LabelYear: UILabel!
    
    @IBOutlet weak var StackSettingsCredit: UIStackView!
    
    @IBOutlet weak var Persent: UILabel!
    @IBOutlet weak var Payment: UILabel!
    
    @IBOutlet weak var YearSlider: UISlider!
    
    private let step: Float = 1
    private let transactionManager : TransactionManager = TransactionManager()
    private let valuteRub = ValuteZaitsevBank.RUB
    private var СreditCheck : CreditCheck?
    
    private var summCredit : Double?
    private var yearCredit : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelYear.text =  "1 год"
        CreditSum.delegate = self
        StackSettingsCredit.isHidden = true
        CreditSum.attributedPlaceholder =
        NSAttributedString(string: "Сумма кредита", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    private func GetCredit() {
        let SummCredit = (CreditSum.text ?? "")
        if (SummCredit.count <= 15){
            let year = round((YearSlider.value - YearSlider.minimumValue) / step)
            let currentValue = year == 0 ? 1 : Int(roundf(year))
            yearCredit = currentValue
            if let (summ, textValute) = SummCredit.convertToDouble(valutePay: valuteRub.rawValue){
                CreditSum.text = textValute
                CreditSum.textColor = .white
                summCredit = summ
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                    Task{
                        if let creditCheck = await transactionManager.CheckCredit(summ: summ, year: currentValue){
                            СreditCheck = creditCheck
                            DispatchQueue.main.async { [self] in
                                StackSettingsCredit.isHidden = false
                                Persent.text = String(creditCheck.persent).replacingOccurrences(of: ".", with: ",") + " %"
                                Payment.text = "\(Double(creditCheck.monthlyPayment).convertedToMoney()) \(valuteRub.description)"
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.summCredit = nil
                                self.CreditSum.textColor = .red
                                self.StackSettingsCredit.isHidden = true
                            }
                        }
                    }
                }
            }
            else {
                summCredit = nil
                StackSettingsCredit.isHidden = true
                CreditSum.textColor = .red
            }
        }
        else {
            summCredit = nil
            StackSettingsCredit.isHidden = true
            CreditSum.textColor = .red
        }
    }
    @IBAction func ShowTable(_ sender: Any) {
        if (СreditCheck != nil){
            let CalculationCredit = storyboard?.instantiateViewController(withIdentifier: "CalculationCredit") as! CalculationCreditController
            CalculationCredit.valute = ValuteZaitsevBank.RUB
            CalculationCredit.credit = СreditCheck
            CalculationCredit.sheetPresentationController?.detents = [.large()]
            present(CalculationCredit, animated: true)
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Не найдены данные о выплатах")
        }
    }
    
    @IBAction func ApplyCredit(_ sender: Any) {
        if summCredit != nil {
            let storyboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
            let CardPick = storyboard.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
            CardPick.textMainLable = "зачисления кредита."
            CardPick.valuteSymbol = valuteRub.rawValue
            CardPick.buySaleToogle = false // Только покупка, чтобы найти рублевые карты
            CardPick.delegate = self
            CardPick.sheetPresentationController?.detents = [.medium()]
            present(CardPick, animated: true)
        }
        else {
            showAlert(withTitle: "Предупреждение", withMessage: "Выберите количество кредитного займа")
        }
    }
    
    @IBAction func SumEditing(_ sender: Any) {
        GetCredit()
    }
    
    @IBAction func YearSliderChanged(_ sender: UISlider) {
        
        let currentValue = round((sender.value - sender.minimumValue) / step)
        switch (currentValue){
        case 0 :
            LabelYear.text =  "1 год"
            break
        case 1 :
            LabelYear.text = String(Int(roundf(currentValue))) + " год"
            break
        case 2 :
            LabelYear.text = String(Int(roundf(currentValue))) + " года"
            break
        case 3 :
            LabelYear.text = String(Int(roundf(currentValue))) + " года"
            break
        case 4 :
            LabelYear.text = String(Int(roundf(currentValue))) + " года"
            break
        default:
            LabelYear.text = String(Int(roundf(currentValue))) + " лет"
        }
        GetCredit()
    }
    
}
extension CreditOfferController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        CreditSum.resignFirstResponder()
        return true;
    }
}
