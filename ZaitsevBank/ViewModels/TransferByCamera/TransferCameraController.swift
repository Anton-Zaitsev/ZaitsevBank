//
//  TransferCameraController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 24.04.2022.
//

import UIKit
class TransferCameraController: UIViewController,CardChoiseDelegate {
    
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        if let CardsUser = Cards {
            configuratedExpence(card: CardsUser[indexPickCard!])
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
    
    @IBOutlet weak var ViewCard: UIView!
    
    private var ValutePay: String?
    private var ValuteClient: String?
    private let cardsManager = CardsManager()
    private var FilterCardID: String? = nil
    private var PayCardID: String? = nil
    private let transactionManager = TransactionManager()
    
    @IBOutlet weak var ViewDataClient: UIView!
    
    @IBOutlet weak var TextNumberPhone: UILabel!
    
    @IBOutlet weak var NameClient: UILabel!
    
    @IBOutlet weak var ImageClient: UILabel!
    
    @IBOutlet weak var TextFieldSumm: UITextField!
    
    //Expance
    @IBOutlet weak var ImageExpence: UIImageView!
    
    @IBOutlet weak var NameCard: UILabel!
    
    @IBOutlet weak var CountLabel: UILabel!
    
    @IBOutlet weak var NumberCard: UILabel!
    
    @IBOutlet weak var SummLabel: UILabel!
    
    @IBOutlet weak var TransferView: UIStackView!
    
    @IBOutlet weak var ValuteA: UILabel!
    
    @IBOutlet weak var ValuteB: UILabel!
    
    private func configuratedExpence (card: Cards)  {
        ImageExpence.image = UIImage(named: card.typeImageCard)
        NameCard.text = card.nameCard
        CountLabel.text = "\(card.moneyCount) \(card.typeMoney)"
        NumberCard.text = card.numberCard
        PayCardID = card.transactionID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        
        TextFieldSumm.delegate = self
        TextNumberPhone.text = "Отсканируйте карту"
        NameClient.text = ""
        
        TransferView.isHidden = true
        
        ImageClient.layer.cornerRadius = ImageClient.bounds.height / 2
        ImageClient.isHidden = true
        ImageClient.layer.masksToBounds = true
        
        TextFieldSumm.attributedPlaceholder =
        NSAttributedString(string: "Сумма зачисления", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        ImageExpence.image = UIImage(named: "")
        NameCard.text = "Отсканируйте карту клиента нажав на надпись"
        CountLabel.text = ""
        NumberCard.text = ""
        
        let tapOffs = UITapGestureRecognizer(target: self, action: #selector(СhoiceCard))
        ViewCard.isUserInteractionEnabled = true
        ViewCard.addGestureRecognizer(tapOffs)
        
        let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
        let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
        storyboardInstance.delegate = self
        storyboardInstance.modalPresentationStyle = .fullScreen
        
        present(storyboardInstance, animated: false, completion: nil)
    }
    
    @objc private func СhoiceCard(sender: UITapGestureRecognizer) {
        if let _ = FilterCardID {
            let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardChoise") as! CardChoiceController
            CardPick.delegate = self
            CardPick.filterCardID = FilterCardID
            CardPick.sheetPresentationController?.detents = [.medium()]
            present(CardPick, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
            let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
            storyboardInstance.delegate = self
            storyboardInstance.modalPresentationStyle = .fullScreen
            present(storyboardInstance, animated: true, completion: nil)
        }
    }
    
    private func ConvertToDouble(Text: String) -> (Double,String)? {
        
        let formatText = String(Text.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  ",", with: ".")
        if let summToInt = Int(formatText){
            let summToIntToDouble = Double(summToInt)
            if (summToIntToDouble.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: ValutePay!)!.CountMaxDouble)){
                
                let fmt = NumberFormatter()
                fmt.numberStyle = .decimal
                fmt.locale = Locale(identifier: "fr_FR")
                return (summToIntToDouble, fmt.string(for: summToInt)! )
            }
            else {
                return nil
            }
        }
        else {
            if let summ = Double (formatText) {
                if (summ.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: ValutePay!)!.CountMaxDouble)){
                    return (summ,formatText.replacingOccurrences(of:  ".", with: ","))
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
    }
    @IBAction func TransferContinue(_ sender: Any) {
        if let cardRecipient = FilterCardID {
            if let cardSender = PayCardID {
                if let summ = Double(TextFieldSumm.text ?? "") {
                let loaderView = EnableLoader()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                    Task{
                        let succ = await transactionManager.TransferClient(TransactionSender: cardSender, TransactionRecipient: cardRecipient, summ: summ)
                        
                            DispatchQueue.main.async { [self] in
                                if (succ){
                                    DisableLoader(loader: loaderView)
                                    showAlert(withTitle: "Успешно", withMessage: "Перевод успешно отправлен")
                                }
                                else {
                                    DisableLoader(loader: loaderView)
                                    showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось сделать перевод")
                                }
                            }
                        }
                    }
                }
                else {
                    showAlert(withTitle: "Произошла ошибка", withMessage: "Вы ввели не верную сумму для перевода")
                    }
            }
            else{
                showAlert(withTitle: "Произошла ошибка", withMessage: "Выберите карту из доступных вам")
            }
        }
        else {
            let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
            let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
            storyboardInstance.delegate = self
            storyboardInstance.modalPresentationStyle = .fullScreen
            present(storyboardInstance, animated: true, completion: nil)
        }
    }
    
    @IBAction func SummEditing(_ sender: Any) {
        if let valutePay = ValutePay {
            if let valuteClient = ValuteClient{
                if (valutePay == ValuteClient) {return}
                if let (valute, textValute) = ConvertToDouble(Text: TextFieldSumm.text ?? ""){
                    TextFieldSumm.textColor = .black
                    TextFieldSumm.text = textValute
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                        Task{
                            if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: valutePay, ValuteB: valuteClient, BuySale: true,valute) {
                                
                                let (valuteA,valuteB) : (String,String) = (ValuteZaitsevBank.init(rawValue: valutePay)?.SaleValuteSubtitle(currentCurse: valuteConvert, count: count, ValuteB: valuteClient))!
                                
                                DispatchQueue.main.async { [self] in
                                    TransferView.isHidden = false
                                    ValuteA.text = valuteA
                                    ValuteB.text = valuteB
                                }
                            }
                        }
                    }
                }
                else {
                    TextFieldSumm.textColor = .red
                }
            }
        }
        
    }
}


extension TransferCameraController: CreditCardScannerViewControllerDelegate {
    func creditCardScannerViewControllerDidCancel(_ viewController: CardScannerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func creditCardScannerViewController(_ viewController: CardScannerController, didErrorWith error: CreditCardScannerError) {
        print(error.errorDescription ?? "")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func creditCardScannerViewController(_ viewController: CardScannerController, didFinishWith card: CreditCard) {
        viewController.dismiss(animated: true, completion: nil)
        
        /*
        var dateComponents = card.expireDate
        dateComponents?.calendar = Calendar.current
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        let date = dateComponents?.date.flatMap(dateFormater.string)
        */
        
        let loader = EnableLoader()
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                let cardManager = CardsManager()
                if let (cardSearch,cardConverted) = await cardManager.GetCardFromNumberCard(numberCard: card.number){
                    
                    ValuteClient = cardSearch.ValuteReceiver
                    ValutePay = cardConverted.typeMoneyExtended
                    FilterCardID = cardSearch.TransactionCard
                    
                    DispatchQueue.main.async { [self] in
                        TextFieldSumm.becomeFirstResponder()
                        SummLabel.text = ValuteClient == ValutePay ? "Сумма в \(ValutePay!)" : "Сумма в \(ValutePay!) с переводом в \(ValuteClient!)"
                        TextNumberPhone.text = cardSearch.PhoneNumber
                        NameClient.text = cardSearch.NameUser
                        ImageClient.text = String(cardSearch.NameUser.first ?? "?")
                        ImageClient.isHidden = false
                        configuratedExpence(card: cardConverted)
                        if (cardSearch.IdeticalValute == false){
                            showAlert(withTitle: "Предупреждение!", withMessage: "У \(cardSearch.NameUser) разная валюта с вашими счетами")
                        }
                        DisableLoader(loader: loader)
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        NameCard.text = "Выбере карту для перевода"
                        DisableLoader(loader: loader)
                        showAlert(withTitle: "Произошла ошибка", withMessage: cardManager.Error)
                    }
                }
                
            }
        }
        /*
        let text = [card.number, date, card.name]
            .compactMap { $0 }
            .joined(separator: "\n")
        
        print("\(text)")
         */
    }
}
extension TransferCameraController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextFieldSumm.resignFirstResponder()
        return true;
    }
}
