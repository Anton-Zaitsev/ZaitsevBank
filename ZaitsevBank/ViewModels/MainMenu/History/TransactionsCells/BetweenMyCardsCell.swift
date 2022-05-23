//
//  BetweenMyCardsCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import UIKit

class BetweenMyCardsCell: UITableViewCell {
    
    @IBOutlet weak var CardNameFrom: UILabel!
    
    @IBOutlet weak var CardNameTo: UILabel!
    
    @IBOutlet weak var TypeOperation: UILabel!
    
    @IBOutlet weak var MoneyCount: UILabel!
    
    @IBOutlet weak var StackTransfer: UIStackView!
    
    @IBOutlet weak var ValuteA: UILabel!
    
    @IBOutlet weak var ValuteB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurated(with Transaction: AllTransactions, with typeOperation: AllTransactionsOperation) {
        
        TypeOperation.text = Transaction.nameTransaction
        CardNameFrom.text = Transaction.transactionValuteBetween!.fromCardName
        CardNameTo.text = Transaction.transactionValuteBetween!.toCardName
        
        if (typeOperation == AllTransactionsOperation.BetweenMyCards){
            StackTransfer.isHidden = true
            let valute = ValuteZaitsevBank.init(rawValue: Transaction.transactionValuteBetween!.valuteType!)!
            MoneyCount.text = "\(valute.electronValute ? Transaction.transactionValuteBetween!.countValute!.valuteToCurseFormat() : Transaction.transactionValuteBetween!.countValute!.valuteToTableFormat()) \(valute.description)"
        }
        else { // AllTransactionsOperation.BetweenMyCardsAndCurrencyTransfer
           
            StackTransfer.isHidden = false
            
            let CountValuteA = Transaction.transactionValuteBetween!.transactionValute!.countValuteA
            let CountValuteB = Transaction.transactionValuteBetween!.transactionValute!.countValuteB
            
            let valuteA = ValuteZaitsevBank.init(rawValue: Transaction.transactionValuteBetween!.transactionValute!.valuteA)!
            let valuteB = ValuteZaitsevBank.init(rawValue: Transaction.transactionValuteBetween!.transactionValute!.valuteB)!
            
            MoneyCount.text = "\(valuteB.electronValute ? CountValuteB.valuteToCurseFormat() : CountValuteB.valuteToTableFormat()) \(valuteB.description)"

            ValuteA.text = "\(valuteA.electronValute ? CountValuteA.valuteToCurseFormat() : CountValuteA.valuteToTableFormat()) \(valuteA.description)"

            ValuteB.text = "\(valuteB.electronValute ? CountValuteB.valuteToCurseFormat() : CountValuteB.valuteToTableFormat()) \(valuteB.description)"

            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
