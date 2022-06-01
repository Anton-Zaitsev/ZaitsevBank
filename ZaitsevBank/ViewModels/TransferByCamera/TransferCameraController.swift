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
    
    public var  SearchCard : (CardSearch,Cards)?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false;
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
        
        TextFieldSumm.isEnabled = false // Блокируем сумму зачисления
        ImageExpence.image = UIImage(systemName: "wand.and.rays")
        NameCard.text = "Отсканируйте карту клиента"
        CountLabel.text = ""
        NumberCard.text = ""
        
        let tapOffs = UITapGestureRecognizer(target: self, action: #selector(СhoiceCard))
        ViewCard.isUserInteractionEnabled = true
        ViewCard.addGestureRecognizer(tapOffs)
        
        if let searchCard = SearchCard {
            configuratedSearchCard(cardData: searchCard)
        }
        else {
            let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
            let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
            storyboardInstance.delegate = self
            storyboardInstance.modalPresentationStyle = .fullScreen
            
            present(storyboardInstance, animated: false, completion: nil)
        }
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
    
    @IBAction func TransferContinue(_ sender: Any) {
        if let cardRecipient = FilterCardID {
            if let cardSender = PayCardID {
                if let summ = (TextFieldSumm.text ?? "").convertDouble() {
                    let loaderView = EnableLoader()
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                        Task{
                            let succ = await transactionManager.TransferClient(TransactionSender: cardSender, TransactionRecipient: cardRecipient, summ: summ)
                            
                            DispatchQueue.main.async { [self] in
                                if (succ){
                                    DisableLoader(loader: loaderView)
                                    
                                    let transactionTemplate = storyboard?.instantiateViewController(withIdentifier: "TransactionTemplate") as! TransactionTemplateController
                                    transactionTemplate.operationName = "Перевод доставлен"
                                    transactionTemplate.operationTitle = "\(TextFieldSumm.text!) \(ValuteZaitsevBank.init(rawValue: ValutePay!)!.description)"
                                    transactionTemplate.operationSubTitle = NameClient.text!
                                    navigationController?.pushViewController(transactionTemplate, animated: true)
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
        ConvertedValuteCheck()
    }
    
    private func configuratedExpence (card: Cards)  {
        ImageExpence.image = UIImage(named: card.typeImageCard)
        NameCard.text = card.nameCard
        CountLabel.text = "\(card.moneyCount) \(card.typeMoney)"
        NumberCard.text = card.numberCard
        PayCardID = card.transactionID
        ValutePay = card.typeMoneyExtended
        
        SummLabel.text = ValuteClient == ValutePay ? "Сумма в \(ValuteZaitsevBank.init(rawValue: ValutePay!)!.description)" : "Сумма в \(ValuteZaitsevBank.init(rawValue: ValutePay!)!.description) с переводом в \(ValuteZaitsevBank.init(rawValue: ValuteClient!)!.description)"
        ConvertedValuteCheck()
    }
    
    private func configuratedSearchCard(cardData: (CardSearch,Cards)) {
        let (cardSearch,cardConverted) = cardData
        
        ValuteClient = cardSearch.ValuteReceiver
        FilterCardID = cardSearch.TransactionCard
        
        configuratedExpence(card: cardConverted)
        
        TextFieldSumm.isEnabled = true // Разблокируем при удачном случае
        TextNumberPhone.text = cardSearch.PhoneNumber.formatPhone()
        NameClient.text = cardSearch.NameUser
        ImageClient.text = String(cardSearch.NameUser.first ?? "?")
        ImageClient.isHidden = false
        if (cardSearch.IdeticalValute == false){
            showAlert(withTitle: "Предупреждение!", withMessage: "У \(cardSearch.NameUser) разная валюта с вашими счетами")
        }
        TextFieldSumm.becomeFirstResponder()
    }
    private func ConvertedValuteCheck() {
        if (ValutePay != nil && ValuteClient != nil){
            if (ValutePay == ValuteClient) {
                TransferView.isHidden = true
                return}
            if ((TextFieldSumm.text ?? "").count <= 15){
                if let (valute, textValute) = (TextFieldSumm.text ?? "").convertToDouble(valutePay: ValutePay!){
                    TextFieldSumm.textColor = .black
                    TextFieldSumm.text = textValute
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                        Task{
                            if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: ValutePay!, ValuteB: ValuteClient!, BuySale: true,valute) {
                                
                                let (valuteA,valuteB) : (String,String) = (ValuteZaitsevBank.init(rawValue: ValutePay!)?.SaleValuteSubtitle(currentCurse: valuteConvert, count: count, ValuteB: ValuteClient!))!
                                
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
            else {
                TextFieldSumm.textColor = .red
            }
        }
    }
}

extension TransferCameraController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextFieldSumm.resignFirstResponder()
        return true;
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
        
        let loader = EnableLoader()
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                let cardManager = CardsManager()
                if let cardSearch = await cardManager.GetCardFromNumberCard(numberCard: card.number){
                    DispatchQueue.main.async { [self] in
                        configuratedSearchCard(cardData: cardSearch)
                        DisableLoader(loader: loader)
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        TextFieldSumm.isEnabled = false // Блокируем сумму зачисления
                        NameCard.text = "Выбере карту для перевода"
                        DisableLoader(loader: loader)
                        showAlert(withTitle: "Произошла ошибка", withMessage: cardManager.Error)
                    }
                }
                
            }
        }
        
        
        /*
         var dateComponents = card.expireDate
         dateComponents?.calendar = Calendar.current
         let dateFormater = DateFormatter()
         dateFormater.dateStyle = .short
         let date = dateComponents?.date.flatMap(dateFormater.string)
         let text = [card.number, date, card.name]
         .compactMap { $0 }
         .joined(separator: "\n")
         
         print("\(text)")
         */
    }
}
