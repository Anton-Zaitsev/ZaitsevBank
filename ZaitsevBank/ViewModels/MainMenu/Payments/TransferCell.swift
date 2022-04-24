//
//  TransferCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 23.04.2022.
//

import UIKit

class TransferCell: UITableViewCell {

    @IBOutlet weak var TitleCell: UILabel!
    @IBOutlet weak var ImageCell: UIImageView!
    
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
