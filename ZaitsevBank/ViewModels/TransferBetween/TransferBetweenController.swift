//
//  TransferBetweenController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.05.2022.
//

import UIKit

class TransferBetweenController: UIViewController,CardChoiseDelegate {
    
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        
        if let CardsUser = Cards {
            
            if (cardPickBuy){
                cardBuy = CardsUser[indexPickCard!]
                configuratedCardBuy()
                getCurrentCurse()
            }
            else {
                TextFieldSumm.isEnabled = true // Включаем textField
                cardSale = CardsUser[indexPickCard!]
                configuratedCardSale()
                getCurrentCurse()
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
    
    
    
    @IBOutlet weak var ViewBuy: UIView!
    @IBOutlet weak var ImageBuy: UIImageView!
    @IBOutlet weak var NameCardBuy: UILabel!
    @IBOutlet weak var NumberCardBuy: UILabel!
    @IBOutlet weak var MoneyCountBuy: UILabel!
    
    @IBOutlet weak var ChangeCards: UIStackView!
    
    
    @IBOutlet weak var ViewPay: UIView!
    @IBOutlet weak var ImagePay: UIImageView!
    @IBOutlet weak var NameCardPay: UILabel!
    @IBOutlet weak var NumberCardPay: UILabel!
    @IBOutlet weak var MoneyCountPay: UILabel!
    
    
    @IBOutlet weak var TypeCardSumm: UILabel!
    @IBOutlet weak var TextFieldSumm: UITextField!
    
    @IBOutlet weak var CurrentСourse: UIStackView!
    @IBOutlet weak var ValuteA: UILabel!
    @IBOutlet weak var ValuteB: UILabel!
    
    private var cardBuy: Cards?
    private var cardSale: Cards?
    private var cardPickBuy: Bool = true
    private let transactionManager = TransactionManager()
    private let cardsManager = CardsManager()
    
    private func configuratedCardBuy() {
        if let card_buy = cardBuy{
            ImageBuy.image = UIImage(named: card_buy.typeImageCard)
            NameCardBuy.text = card_buy.nameCard
            MoneyCountBuy.text = "\(card_buy.moneyCount) \(card_buy.typeMoney)"
            NumberCardBuy.text = card_buy.numberCard
            TypeCardSumm.text = ValuteZaitsevBank.init(rawValue: cardBuy!.typeMoneyExtended)?.description
        }
        else {
            NumberCardBuy.text = ""
            MoneyCountBuy.text = ""
            ImageBuy.image = UIImage(systemName: "wand.and.rays")
            NameCardBuy.text = "Выберите карту списания"
            TypeCardSumm.text = ""
        }
    }
    
    private func configuratedCardSale() {
        if let card_sale = cardSale{
            ImagePay.image = UIImage(named: card_sale.typeImageCard)
            NameCardPay.text = card_sale.nameCard
            MoneyCountPay.text = "\(card_sale.moneyCount) \(card_sale.typeMoney)"
            NumberCardPay.text = card_sale.numberCard
        }
        else {
            NumberCardPay.text = ""
            MoneyCountPay.text = ""
            ImagePay.image = UIImage(systemName: "wand.and.rays")
            NameCardPay.text = "Выберите карту зачисления"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextFieldSumm.delegate = self
        setNavigationBar("Перевод между счетами")
        
        TextFieldSumm.attributedPlaceholder =
        NSAttributedString(string: "Сумма зачисления", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        configuratedCardBuy()
        configuratedCardSale()
        
        TextFieldSumm.isEnabled = false // Отключаем textField
        CurrentСourse.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapCardBuy = UITapGestureRecognizer(target: self, action: #selector(СhoiceCardBuy))
        ViewBuy.isUserInteractionEnabled = true
        ViewBuy.addGestureRecognizer(tapCardBuy)
        
        let tapCardSale = UITapGestureRecognizer(target: self, action: #selector(СhoiceCardSale))
        ViewPay.isUserInteractionEnabled = true
        ViewPay.addGestureRecognizer(tapCardSale)
        
        
        let tapChangeCards = UITapGestureRecognizer(target: self, action: #selector(ChoiseChangesCards))
        ChangeCards.isUserInteractionEnabled = true
        ChangeCards.addGestureRecognizer(tapChangeCards)
    }
    
    @objc private func СhoiceCardBuy(sender: UITapGestureRecognizer) {
        cardPickBuy = true
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardChoise") as! CardChoiceController
        CardPick.delegate = self
        CardPick.filterCardID = cardSale != nil ? cardSale?.transactionID : nil
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
        
    }
    
    @objc private func СhoiceCardSale(sender: UITapGestureRecognizer) {
        cardPickBuy = false
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardChoise") as! CardChoiceController
        CardPick.delegate = self
        CardPick.filterCardID = cardBuy != nil ? cardBuy?.transactionID : nil
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
        
    }
    
    @objc private func ChoiseChangesCards(sender: UITapGestureRecognizer) {
        if let card_buy = cardBuy{
            if let card_sale = cardSale{
                cardBuy = card_sale
                cardSale = card_buy
                configuratedCardBuy()
                configuratedCardSale()
                getCurrentCurse()
            }
            else {
                NameCardPay.textColor = .red
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.NameCardPay.textColor = .white
                }
            }
        }
        else {
            NameCardBuy.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.NameCardBuy.textColor = .white
            }
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    private func getCurrentCurse() {
        if (cardBuy != nil && cardSale != nil) {
            if (cardBuy?.typeMoneyExtended == cardSale?.typeMoneyExtended) {
                CurrentСourse.isHidden = true
                return}
            if ((TextFieldSumm.text ?? "").count <= 15){
                if let (valute, textValute) = (TextFieldSumm.text ?? "").convertToDouble(valutePay: cardBuy!.typeMoneyExtended){
                    TextFieldSumm.textColor = .white
                    TextFieldSumm.text = textValute
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                        Task{
                            if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: cardBuy!.typeMoneyExtended, ValuteB: cardSale!.typeMoneyExtended, BuySale: true,valute) {
                                
                                let (valuteA,valuteB) : (String,String) = (ValuteZaitsevBank.init(rawValue: cardBuy!.typeMoneyExtended)?.SaleValuteSubtitle(currentCurse: valuteConvert, count: count, ValuteB: cardSale!.typeMoneyExtended))!
                                
                                DispatchQueue.main.async { [self] in
                                    CurrentСourse.isHidden = false
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
    @IBAction func TransferEdit(_ sender: Any) {
        getCurrentCurse()
    }
    @IBAction func TransferBetweenClick(_ sender: Any) {
        if (cardBuy != nil) {
            if (cardSale != nil){
                
                if let summ = (TextFieldSumm.text ?? "").convertToDouble(valutePay: cardBuy!.typeMoneyExtended) {
                    
                    if (summ.0 <= cardBuy!.moneyCount.convertDouble()!){
                        let loaderView = EnableLoader()
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                            Task{
                                let succ = await transactionManager.TransferClient(TransactionSender: cardBuy!.transactionID, TransactionRecipient: cardSale!.transactionID, summ: summ.0)
                                
                                DispatchQueue.main.async { [self] in
                                    if (succ){
                                        DisableLoader(loader: loaderView)
                                        
                                        let transactionTemplate = storyboard?.instantiateViewController(withIdentifier: "TransactionTemplate") as! TransactionTemplateController
                                        transactionTemplate.operationName = "Перевод"
                                        transactionTemplate.operationTitle = "\(TextFieldSumm.text!) \(ValuteZaitsevBank.init(rawValue: cardBuy!.typeMoneyExtended)!.description)"
                                        transactionTemplate.operationSubTitle = "Перевод между своими счетами"
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
                else {
                    showAlert(withTitle: "Произошла ошибка", withMessage: "Вы ввели не верную сумму для перевода")
                }
            }
            else {
                showAlert(withTitle: "Произошла ошибка", withMessage: "Выберите карту для зачисления")
            }
        }
        else {
            showAlert(withTitle: "Произошла ошибка", withMessage: "Выберите карту для списания")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false;
        
        if (cardBuy == nil){
            let loader = EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    let cards = await CardsManager().GetAllCards()
                    if (cards.isEmpty == false){
                        cardBuy = cards.first
                    }
                    DispatchQueue.main.async { [self] in
                        configuratedCardBuy()
                        DisableLoader(loader: loader)
                    }
                }
            }
        }
    }
    
}
extension TransferBetweenController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextFieldSumm.resignFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: true)
        return true;
    }
}
