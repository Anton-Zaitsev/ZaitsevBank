//
//  PaymentCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.04.2022.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    
    @IBOutlet weak var TitleCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with operation: HistoryOperationPayments) {
        
        TitleCell.text = operation.nameOperation
        ImageCell.image = operation.iconOperation
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
