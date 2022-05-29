//
//  PayCreditCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.05.2022.
//

import UIKit

class PayCreditCell: UITableViewCell {

    @IBOutlet weak var NumberCredit: UILabel!
    @IBOutlet weak var TypeTransaction: UILabel!
    @IBOutlet weak var ViewCreditFill: LineView!
    @IBOutlet weak var CountMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configurated(with Transaction: AllTransactions, with typeOperation: AllTransactionsOperation) {
        let valute = ValuteZaitsevBank.RUB
        NumberCredit.text = "Договор: \(Transaction.transactionCredit!.numberDocument)"
        CountMoney.text = "\(Transaction.transactionCredit!.countMoney.convertedToMoneyValute(valute: valute)) \(valute.description)"
        TypeTransaction.text = Transaction.nameTransaction
        let valuteNotPay = 1 - Transaction.transactionCredit!.progress
        ViewCreditFill.colors = [
            UIColor("#35C759"), UIColor("#555555")
        ]
        ViewCreditFill.values = [CGFloat(Transaction.transactionCredit!.progress), CGFloat(valuteNotPay)]
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
