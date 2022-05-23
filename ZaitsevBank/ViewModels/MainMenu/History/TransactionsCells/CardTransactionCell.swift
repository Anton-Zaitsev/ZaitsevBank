//
//  CardTransactionCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.05.2022.
//

import UIKit

class CardTransactionCell: UITableViewCell {

    @IBOutlet weak var NameCard: UILabel!
    @IBOutlet weak var TypeTransaction: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurated(with Transaction: AllTransactions, with typeOperation: AllTransactionsOperation) {
        NameCard.text = Transaction.transactionCardOrCredit!.name
        TypeTransaction.text = Transaction.nameTransaction
        Status.text = Transaction.transactionCardOrCredit!.activation ? "Успешно выполнена" : "Карта заблокирована"
        Status.textColor = Transaction.transactionCardOrCredit!.activation ? .green : .red
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
