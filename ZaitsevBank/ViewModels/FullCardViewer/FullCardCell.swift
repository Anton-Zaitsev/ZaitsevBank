//
//  FullCardCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.11.2021.
//

import UIKit

class FullCardCell: UICollectionViewCell {
    
    @IBOutlet weak var LabelMoney: UILabel!
    @IBOutlet weak var LabelMoneyType: UILabel!
    
    
    @IBOutlet weak var ViewPayOrTranslate: UIView!
    @IBOutlet weak var ViewTopUp: UIView!
    
    @IBOutlet weak var ViewRequisites: UIView!
    @IBOutlet weak var ViewSettings: UIView!
    
    
    //CARD FRONT
    @IBOutlet weak var FrontCardView: UIView!
    @IBOutlet weak var BackroundImageFrontCard: UIImageView!
    @IBOutlet weak var ImageTypeFrontCard: UIImageView!
    @IBOutlet weak var NumberCardFront: UILabel!
    
    //CARD BACK
    @IBOutlet weak var BackCardView: UIView!
    @IBOutlet weak var ViewNumberCard: UIView!
    @IBOutlet weak var LabelNumberCard: UILabel!
    
    @IBAction func SeeLabelNumber(_ sender: Any) {
        LabelNumberCard.text = LabelCardNumberData
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.LabelNumberCard.text = self.LabelNumberCardData
        }
    }
    
    @IBOutlet weak var ViewCVVCard: UIView!
    @IBOutlet weak var LabelCVVCard: UILabel!
    @IBOutlet weak var LabelDataCard: UILabel!
    @IBOutlet weak var LabelDataDetailed: UILabel!
    
    @IBAction func SeeLabelCVV(_ sender: Any) {
        LabelCVVCard.text = LabelCardCVVData
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.LabelCVVCard.text = "•••"
        }
    }
    
    private var LabelCardNumberData : String = ""
    private var LabelCardCVVData : String = ""
    private var LabelNumberCardData : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getView()
    }
    private func getView() {
        FrontCardView.isHidden = false
        BackCardView.isHidden = true
        
        FrontCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        FrontCardView.isUserInteractionEnabled = true
        BackCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        BackCardView.isUserInteractionEnabled = true
        
        
        FrontCardView.layer.cornerRadius = 15
        BackCardView.layer.cornerRadius = 15
        
        ViewPayOrTranslate.layer.cornerRadius = 10
        ViewTopUp.layer.cornerRadius = 10
        ViewRequisites.layer.cornerRadius = 10
        ViewSettings.layer.cornerRadius = 10
        
        BackroundImageFrontCard.layer.cornerRadius = 15
        
        ViewNumberCard.layer.cornerRadius = 8
        ViewCVVCard.layer.cornerRadius = 8
    }
    func configurated(with data: Cards) {
        
        LabelMoney.text = "\(data.moneyCount) \(data.typeMoney)"
        
        LabelMoneyType.text = ValuteZaitsevBank(rawValue: data.typeMoneyExtended)?.descriptionTypeValute ?? "Неизвестная валюта"
        
        BackroundImageFrontCard.image = UIImage(named: data.cardOperator == "MIR" ? "BacroundCardTypeMIR" : "BacroundCardTypeDefault")
        ImageTypeFrontCard.image = UIImage(named: CardType(rawValue: data.cardOperator)?.logoCardOperator ?? "")
        NumberCardFront.text = data.numberCard
        
        let index = data.fullNumberCard.index(data.fullNumberCard.endIndex, offsetBy: -4)
        
        LabelNumberCardData = "•••• •••• •••• " + String(data.fullNumberCard.suffix(from: index))
        LabelNumberCard.text = LabelNumberCardData
        
        LabelCardNumberData = data.fullNumberCard
        LabelCardCVVData = data.cvv
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "MM/yy"
        LabelDataCard.text = formatDate.string(from: data.data)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let month = Int(dateFormatter.string(from: data.data))!
        let monthAsString:String = dateFormatter.monthSymbols[month - 1]
        
        LabelDataDetailed.text = "Можно пользоваться до 29 \(monthAsString)"
       
    }
    
    @objc private func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tag = gestureRecognizer.view?.tag
        switch tag! {
        case 0 :
            BackCardView.showFlip()
            FrontCardView.hideFlip()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.BackCardView.hideFlip()
                self.FrontCardView.showFlip()
            }
        case 1 :
            BackCardView.hideFlip()
            FrontCardView.showFlip()
        default:
            print("default")
        }
    }
}
