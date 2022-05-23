//
//  InOutcomingCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import UIKit

class InOutcomingCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    
    @IBOutlet weak var TitleOperation: UILabel!
    @IBOutlet weak var NameOperation: UILabel!
    
    @IBOutlet weak var MoneyOperation: UILabel!
    @IBOutlet weak var ImageMoneyOperation: UIImageView!
    
    @IBOutlet weak var StackTransfer: UIStackView!
    @IBOutlet weak var ValuteA: UILabel!
    @IBOutlet weak var ValuteB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configurated(with Transaction: AllTransactions, with typeOperation: AllTransactionsOperation) {
        NameOperation.text = Transaction.nameTransaction
        
        if (typeOperation == AllTransactionsOperation.IncomingTransfer || typeOperation == AllTransactionsOperation.OutgoingTransfer){
            
            let valute = ValuteZaitsevBank.init(rawValue: Transaction.transactionPaymentServices!.valuteType)!
            ImageCell.image = UIImage(named: typeOperation == AllTransactionsOperation.IncomingTransfer ? "IngoingIcon" : "OutgoingIcon")
            TitleOperation.text = Transaction.transactionPaymentServices!.nameClient
            
            StackTransfer.isHidden = true
            
            if (typeOperation == AllTransactionsOperation.IncomingTransfer){
                ImageMoneyOperation.isHidden = true
                MoneyOperation.textColor = UIColor("#35C759")
                MoneyOperation.text = "+ \(valute.electronValute ? Transaction.transactionPaymentServices!.countMoney.valuteToCurseFormat() : Transaction.transactionPaymentServices!.countMoney.valuteToTableFormat()) \(valute.description)"
            }
            else {
                ImageMoneyOperation.isHidden = false
                MoneyOperation.textColor = .white
                MoneyOperation.text = "\(valute.electronValute ? Transaction.transactionPaymentServices!.countMoney.valuteToCurseFormat() : Transaction.transactionPaymentServices!.countMoney.valuteToTableFormat()) \(valute.description)"
            }
            
        }
        else if (typeOperation == AllTransactionsOperation.IncomingTransferAndCurrencyTransfer || typeOperation == AllTransactionsOperation.OutgoingTransferAndCurrencyTransfer){
            
            let valute = ValuteZaitsevBank.init(rawValue: Transaction.transactionPaymentServices!.valuteType)!
            
            ImageCell.image = UIImage(named: typeOperation == AllTransactionsOperation.IncomingTransferAndCurrencyTransfer ? "IngoingIcon" : "OutgoingIcon")
            
            TitleOperation.text = Transaction.transactionPaymentServices!.nameClient
            
            StackTransfer.isHidden = false
            
            let valuteA = ValuteZaitsevBank.init(rawValue: Transaction.transactionPaymentServices!.transactionValute!.valuteA)!
            
            let valuteB = ValuteZaitsevBank.init(rawValue: Transaction.transactionPaymentServices!.transactionValute!.valuteB)!
            
            ValuteA.text = "\(valuteA.electronValute ? Transaction.transactionPaymentServices!.transactionValute!.countValuteA.valuteToCurseFormat() : Transaction.transactionPaymentServices!.transactionValute!.countValuteA.valuteToTableFormat()) \(valuteA.description)"
            
            ValuteB.text = "\(valuteB.electronValute ? Transaction.transactionPaymentServices!.transactionValute!.countValuteB.valuteToCurseFormat() : Transaction.transactionPaymentServices!.transactionValute!.countValuteB.valuteToTableFormat()) \(valuteB.description)"
            
            if (typeOperation == AllTransactionsOperation.IncomingTransferAndCurrencyTransfer){
                ImageMoneyOperation.isHidden = true
                MoneyOperation.textColor = UIColor("#35C759")
                MoneyOperation.text = "+ \(valute.electronValute ? Transaction.transactionPaymentServices!.countMoney.valuteToCurseFormat() : Transaction.transactionPaymentServices!.countMoney.valuteToTableFormat()) \(valute.description)"
            }
            else {
                ImageMoneyOperation.isHidden = false
                MoneyOperation.textColor = .white
                MoneyOperation.text = "\(valute.electronValute ? Transaction.transactionPaymentServices!.countMoney.valuteToCurseFormat() : Transaction.transactionPaymentServices!.countMoney.valuteToTableFormat()) \(valute.description)"
            }
        }

        else if (typeOperation == AllTransactionsOperation.TakeCredit){
            let valute = ValuteZaitsevBank.init(rawValue: Transaction.transactionPaymentServices!.valuteType)!
            
            ImageCell.image = UIImage(named: "TakeCredit")
            TitleOperation.text = Transaction.transactionPaymentServices!.nameClient
            StackTransfer.isHidden = true
            ImageMoneyOperation.isHidden = true
            MoneyOperation.textColor = .white
            
            MoneyOperation.text = "\(valute.electronValute ? Transaction.transactionPaymentServices!.countMoney.valuteToCurseFormat() : Transaction.transactionPaymentServices!.countMoney.valuteToTableFormat()) \(valute.description)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
