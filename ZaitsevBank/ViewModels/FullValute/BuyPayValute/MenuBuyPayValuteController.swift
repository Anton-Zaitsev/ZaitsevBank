//
//  MenuBuyPayValuteController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 12.04.2022.
//

import UIKit

class MenuBuyPayValuteController: UIViewController,CardPickDelegate {
    
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        
        if let CardsUser = Cards {
            СhoiceCard ? configuratedViewOffs(data: CardsUser[indexPickCard!]) : configuratedViewEnrollment(data: CardsUser[indexPickCard!])
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
                            
                            if (self.BuySaleToogle!){ // Если валюту нужно создать единсвенную выбранную, любую, тогда не нужно создавать экземпляр валюты
                                AddNewCardController.ValutePick = self.TypeValuteEnrollment!
                            }
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
    
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    // Счет списания
    @IBOutlet weak var NamePayCard: UILabel!
    
    @IBOutlet weak var ImagePayCard: UIImageView!
    
    @IBOutlet weak var NumberPayCard: UILabel!
    
    @IBOutlet weak var MoneyPayCard: UILabel!
    //
    
    //Счет Зачисления
    @IBOutlet weak var NameBuyCard: UILabel!
    
    @IBOutlet weak var ImageBuyCard: UIImageView!
    
    @IBOutlet weak var NumberBuyCard: UILabel!
    
    @IBOutlet weak var MoneyBuyCard: UILabel!
    //
    
    @IBOutlet weak var TextFieldSUMM: UITextField!
    
    @IBOutlet weak var ValuteRUB: UILabel!
    
    @IBOutlet weak var ValuteUSD: UILabel!
    
    @IBOutlet weak var ValuteEUR: UILabel!
    
    @IBOutlet weak var ValuteBTC: UILabel!
    
    @IBOutlet weak var ValuteETH: UILabel!
    
    @IBOutlet weak var TextNewCard: UILabel!
    
    @IBOutlet weak var ViewOffs: UIView! // View валюты Списания
    
    @IBOutlet weak var ViewEnrollment: UIView!
    // View валюты Зачисления
    
    @IBOutlet weak var ViewNewCard: UIStackView!
    
    @IBOutlet weak var ValuteCount: UIView!
    
    @IBOutlet weak var StackValute: UIStackView!
    
    
    
    public var cardBuy: [Cards] = [] // Тип карты Списания
    private var cardPay: [Cards] = [] // Тип карты Зачисления
    
    private let cardsManager = CardsManager()
    private var СhoiceCard = true // Дефолтное значение для выбора карт для Списания ... false для зачисления
    
    public var BuySaleToogle: Bool?
    
    public var TypeValuteOffs : String? // Тип валюты Списания
    public var TypeValuteEnrollment: String? // Тип валюты Зачисления
    
    public var IndexFirstCard: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFieldSUMM.delegate = self
        ViewNewCard.isHidden = true
        ValuteCount.isHidden = true
        StackValute.isHidden = true
        
        configuratedViewOffs(data: cardBuy[IndexFirstCard!]) // Конфигурация настроек для Счета Списания
        
        ValuteRUB.layer.cornerRadius = ValuteRUB.frame.height / 2
        ValuteRUB.layer.masksToBounds = true
        ValuteUSD.layer.cornerRadius = ValuteUSD.frame.height / 2
        ValuteUSD.layer.masksToBounds = true
        ValuteEUR.layer.cornerRadius = ValuteEUR.frame.height / 2
        ValuteEUR.layer.masksToBounds = true
        ValuteBTC.layer.cornerRadius = ValuteBTC.frame.height / 2
        ValuteBTC.layer.masksToBounds = true
        ValuteETH.layer.cornerRadius = ValuteETH.frame.height / 2
        ValuteETH.layer.masksToBounds = true
        
        TextFieldSUMM.attributedPlaceholder =
        NSAttributedString(string: "Сумма зачисления", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        NameBuyCard.text = "Загрузка карты ..."
        TextNewCard.text = ""
        TitleLabel.text = ""
        
        NumberBuyCard.isHidden = true
        MoneyBuyCard.isHidden = true
        
        let tapOffs = UITapGestureRecognizer(target: self, action: #selector(СhoiceCardOffs))
        ViewOffs.isUserInteractionEnabled = true
        ViewOffs.addGestureRecognizer(tapOffs)
        
        let tapEnrollment = UITapGestureRecognizer(target: self, action: #selector(СhoiceCardEnrollment))
        ViewEnrollment.isUserInteractionEnabled = true
        ViewEnrollment.addGestureRecognizer(tapEnrollment)
        
    }
    
    @objc private func СhoiceCardOffs(sender: UITapGestureRecognizer) {
        СhoiceCard = true
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
        CardPick.valuteSymbol = TypeValuteOffs
        CardPick.cardUser = cardBuy
        CardPick.textMainLable = "списания."
        CardPick.delegate = self
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
    }
    
    @objc private func СhoiceCardEnrollment(sender: UITapGestureRecognizer) {
        СhoiceCard = false
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
        CardPick.valuteSymbol = TypeValuteEnrollment
        CardPick.buySaleToogle = BuySaleToogle! ? false : true // Toogle только для поиска
        CardPick.cardUser = cardPay
        CardPick.textMainLable = "зачисления."
        CardPick.delegate = self
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
    }
    
    private func configuratedViewOffs(data: Cards){
        NamePayCard.text = data.nameCard
        ImagePayCard.image = UIImage(named: data.typeImageCard)
        NumberPayCard.text = data.numberCard
        
        MoneyPayCard.text = "\(data.moneyCount) \(data.typeMoney)"
        
        TypeValuteOffs = data.typeMoneyExtended // Новая валюта списания
        
        if (cardPay.isEmpty == false) { // Если валюта зачисления есть
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: TypeValuteOffs!, ValuteB: TypeValuteEnrollment!, BuySale: BuySaleToogle!, (TextFieldSUMM.text ?? "").convertDouble()) {
                        
                        DispatchQueue.main.async { [self] in
                            
                            TitleLabel.text = ValuteZaitsevBank.init(rawValue: TypeValuteOffs!)?.SaleValuteTitle(buySale: BuySaleToogle!, currentCurse: valuteConvert,count: count, ValuteB: TypeValuteEnrollment!)
                        }
                    }
                }
            }
        }
        
    }
    
    private func configuratedViewEnrollment(data: Cards){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                let TypeValuteB = data.typeMoneyExtended // Зачислем на нашу карту VALUTE
                
                if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: TypeValuteOffs!, ValuteB: TypeValuteB, BuySale: BuySaleToogle!, (TextFieldSUMM.text ?? "").convertDouble()) {
                    
                    DispatchQueue.main.async { [self] in
                        
                        NameBuyCard.text = data.nameCard
                        ImageBuyCard.image = UIImage(named: data.typeImageCard)
                        NumberBuyCard.text = data.numberCard
                        MoneyBuyCard.text = "\(data.moneyCount) \(data.typeMoney)"
                        pickValute(valute: TypeValuteB)
                        
                        TypeValuteEnrollment = data.typeMoneyExtended // Указать новый тип валюты зачисления
                        
                        TitleLabel.text = ValuteZaitsevBank.init(rawValue: TypeValuteOffs!)?.SaleValuteTitle(buySale: BuySaleToogle!, currentCurse: valuteConvert,count: count, ValuteB: TypeValuteEnrollment!)
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        ImageBuyCard.image = UIImage(systemName: "wand.and.rays")
                        NameBuyCard.text = "Оформите новый счет"
                        ViewNewCard.isHidden = false
                    }
                }
                
            }
        }
    }
    
    //Если buyPay - то покупка, иначе продажа
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(cardPay.isEmpty){
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    TypeValuteOffs = cardBuy[IndexFirstCard!].typeMoneyExtended // Списываем с нашей карты idVALUTE VALUTE A
                    
                    cardPay = await cardsManager.GetCardsBuySale(TypeValute: TypeValuteEnrollment!, BuySale: BuySaleToogle! ? false : true) // Меняем buySale для того, чтобы найти карты для зачисления на
                    if (cardPay.isEmpty == false) {
                        configuratedViewEnrollment(data: cardPay.first!) // Конфигурация для зачисления
                        
                        DispatchQueue.main.async { [self] in
                            ImageBuyCard.isHidden = false
                            NumberBuyCard.isHidden = false
                            MoneyBuyCard.isHidden = false
                            ValuteCount.isHidden = false
                            
                            StackValute.isHidden = false
                            
                            DisableLoader(loader: loader)
                        }
                        
                    }
                    else {
                        DispatchQueue.main.async { [self] in
                            TextNewCard.text = BuySaleToogle! ? "Для завершения операции вам необходимо открыть счет в \(ValuteZaitsevBank.init(rawValue: TypeValuteEnrollment!)!.descriptionExpense)." : "Для завершения операции вам необходимо открыть новый счет в другой валюте."
                            
                            ImageBuyCard.image = UIImage(systemName: "wand.and.rays")
                            
                            NameBuyCard.text = "Оформите новый счет"
                            ViewNewCard.isHidden = false
                            DisableLoader(loader: loader)
                        }
                    }
                }
            }
        }
    }
    
    
    private func pickValute(valute: String) {
        let valute = ValuteZaitsevBank.init(rawValue: valute)
        let defaultColor = UIColor("#343434")
        
        ValuteRUB.backgroundColor = defaultColor
        ValuteRUB.textColor = .white
        ValuteUSD.backgroundColor = defaultColor
        ValuteUSD.textColor = .white
        ValuteEUR.backgroundColor = defaultColor
        ValuteEUR.textColor = .white
        ValuteBTC.backgroundColor = defaultColor
        ValuteBTC.textColor = .white
        ValuteETH.backgroundColor = defaultColor
        ValuteETH.textColor = .white
        
        
        switch valute {
        case .RUB :
            ValuteRUB.backgroundColor = .white
            ValuteRUB.textColor = defaultColor
            break
        case .USD :
            ValuteUSD.backgroundColor = .white
            ValuteUSD.textColor = defaultColor
            break
        case .EUR :
            ValuteEUR.backgroundColor = .white
            ValuteEUR.textColor = defaultColor
            break
        case .BTC :
            ValuteBTC.backgroundColor = .white
            ValuteBTC.textColor = defaultColor
            break
        case .ETH :
            ValuteETH.backgroundColor = .white
            ValuteETH.textColor = defaultColor
        default: break
        }
        
    }
    
    @IBAction func ChangedTextFieldSUMM(_ sender: Any) {
        
        if ((TextFieldSUMM.text ?? "").count <= 15){
            if let (valute, textValute) = (TextFieldSUMM.text ?? "").convertToDouble(valutePay: TypeValuteOffs!){
                TextFieldSUMM.textColor = .white
                TextFieldSUMM.text = textValute
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                    Task{
                        if let (valuteConvert,count,_ ) = await cardsManager.ConvertValute(ValuteA: TypeValuteOffs!, ValuteB: TypeValuteEnrollment!, BuySale: BuySaleToogle!,valute) {
                            
                            DispatchQueue.main.async { [self] in
                                TitleLabel.text = ValuteZaitsevBank.init(rawValue: TypeValuteOffs!)?.SaleValuteTitle(buySale: BuySaleToogle!, currentCurse: valuteConvert,count: count, ValuteB: TypeValuteEnrollment!)
                            }
                        }
                    }
                }
            }
            else {
                TextFieldSUMM.textColor = .red
            }
        }
        else {
            TextFieldSUMM.textColor = .red
        }
        
    }
    
    @IBAction func AddNewCard(_ sender: Any) {
        
        let loader = self.EnableLoader()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            Task(priority: .medium) {
                
                if let data = await AccountManager().GetUserData(){
                    DispatchQueue.main.async {
                        let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                        let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                        AddNewCardController.nameFamilyOwner = "\(data.firstName) \(data.lastName)"
                        
                        if (self.BuySaleToogle!){ // Если валюту нужно создать единсвенную выбранную, любую, тогда не нужно создавать экземпляр валюты
                            AddNewCardController.ValutePick = self.TypeValuteEnrollment!
                        }
                        
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
extension MenuBuyPayValuteController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextFieldSUMM.resignFirstResponder()
        return true;
    }
}
