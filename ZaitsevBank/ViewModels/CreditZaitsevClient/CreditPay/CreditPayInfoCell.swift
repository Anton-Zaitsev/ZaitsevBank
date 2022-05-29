//
//  CreditPayInfoCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 28.05.2022.
//

import UIKit

class CreditPayInfoCell: UITableViewCell {

    @IBOutlet weak var ContentCell: UIView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var OperationInfo: UILabel!
    
    @IBOutlet weak var MoneyLabel: UILabel!
    
    @IBOutlet weak var RemainsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurated(with credit: CreditPaysTransaction, with valute: ValuteZaitsevBank) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MMMM, yyyy"
        
        MonthLabel.text = dateformat.string(from: credit.datePay)
        MoneyLabel.text = "\(credit.summCredit.convertedToMoney()) \(valute.description)"
        
        RemainsLabel.text = "Остаток: \(credit.balanceCredit.convertedToMoney()) \(valute.description)"
        if (credit.overdue){
            MoneyLabel.textColor = .red
            ContentCell.alpha = 1
            OperationInfo.textColor = .red
            OperationInfo.text = "Просроченная оплата"
        }
        else {
            if (credit.waiting){
                MoneyLabel.textColor = .systemGreen
                ContentCell.alpha = 1
                OperationInfo.text = "Ожидается оплата"
                OperationInfo.textColor = .darkGray
                
            }
            else {
                MoneyLabel.textColor = .white
                ContentCell.alpha = 0.5
                OperationInfo.text = "В скором времени"
                OperationInfo.textColor = .darkGray
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
