//
//  CurrencyTransferCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import UIKit

class CurrencyTransferCell: UITableViewCell {

    @IBOutlet weak var NameCardFrom: UILabel!
    @IBOutlet weak var NameCardTo: UILabel!
    
    @IBOutlet weak var TypeOperation: UILabel!
    
    @IBOutlet weak var ValuteA: UILabel!
    @IBOutlet weak var ValuteB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurated(with Transaction: AllTransactions, with typeOperation: AllTransactionsOperation) {
        NameCardFrom.text = Transaction.transactionValuteBetween!.fromCardName
        NameCardFrom.text = Transaction.transactionValuteBetween!.toCardName
        
        let valuteA = ValuteZaitsevBank.init(rawValue: Transaction.transactionValuteBetween!.transactionValute!.valuteA)!
        
        let valuteB = ValuteZaitsevBank.init(rawValue: Transaction.transactionValuteBetween!.transactionValute!.valuteB)!
        
        let CountValuteA = Transaction.transactionValuteBetween!.transactionValute!.countValuteA
        let CountValuteB = Transaction.transactionValuteBetween!.transactionValute!.countValuteB
        
        ValuteA.text = "\(valuteA.electronValute ? CountValuteA.valuteToCurseFormat() : CountValuteA.valuteToTableFormat()) \(valuteA.description)"

        ValuteB.text = "\(valuteB.electronValute ? CountValuteB.valuteToCurseFormat() : CountValuteB.valuteToTableFormat()) \(valuteB.description)"
        
        
        TypeOperation.text = Transaction.transactionValuteBetween!.transactionValute!.buySale ? "Покупка валюты" : "Продажа валюты"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
