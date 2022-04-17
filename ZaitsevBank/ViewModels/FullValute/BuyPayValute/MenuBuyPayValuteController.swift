//
//  MenuBuyPayValuteController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 12.04.2022.
//

import UIKit

class MenuBuyPayValuteController: UIViewController {
    
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
    
    @IBOutlet weak var ViewNewCard: UIStackView!
    
    @IBOutlet weak var TextNewCard: UILabel!
    
    public var cardBuy: [Cards] = []
    private var cardPay: [Cards] = []
    
    public var BuySaleToogle: Bool = false
    public var TypeValuteBuy: String = ""
    public var IndexFirstCard: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NamePayCard.text = cardBuy[IndexFirstCard].nameCard
        ImageBuyCard.image = UIImage(named: cardBuy[IndexFirstCard].typeImageCard)
        NumberBuyCard.text = cardBuy[IndexFirstCard].numberCard
        
        MoneyBuyCard.text = "\(cardBuy[IndexFirstCard].moneyCount) \(cardBuy[IndexFirstCard].typeMoney)"
        TypeValuteBuy = cardBuy[IndexFirstCard].typeMoneyExtended
        
        TitleLabel.text = ValuteZaitsevBank.init(rawValue: TypeValuteBuy)?.SaleValuteTitle(buySale: BuySaleToogle, currentCurse: "228")
        
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
        ImageBuyCard.isHidden = true
        NumberBuyCard.isHidden = true
        MoneyBuyCard.isHidden = true
    }
    
    //Если buyPay - то покупка, иначе продажа
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(cardPay.isEmpty){
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    cardPay = await CardsManager().GetCardsBuySale(TypeValute: TypeValuteBuy, BuySale: BuySaleToogle)
                    DispatchQueue.main.async { [self] in
                        if (cardPay.isEmpty == false) {
                            pickValute(valute: cardPay.first!.typeMoneyExtended)
                            
                            NameBuyCard.text = cardPay.first!.nameCard
                            ImageBuyCard.image = UIImage(named: cardPay.first!.typeImageCard)
                            ImageBuyCard.isHidden = false
                            NumberBuyCard.text = cardPay.first!.numberCard
                            NumberBuyCard.isHidden = false
                            MoneyBuyCard.text = "\(cardPay.first!.moneyCount) \(cardPay.first!.typeMoney)"
                            MoneyBuyCard.isHidden = false
                        }
                        DisableLoader(loader: loader)
                    }
                }
            }
        }
    }
    
    
    private func pickValute(valute: String) {
        let valute = ValuteZaitsevBank.init(rawValue: TypeValuteBuy)
        let defaultColor = UIColor(red: 52, green: 52, blue: 52, alpha: 0)
        
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
    
    @IBAction func AddNewCard(_ sender: Any) {
        
    }
    
}
