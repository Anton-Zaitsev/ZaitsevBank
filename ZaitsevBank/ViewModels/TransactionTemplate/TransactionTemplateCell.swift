//
//  TransactionTemplateCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import UIKit

class TransactionTemplateCell: UITableViewCell {

    @IBOutlet weak var TitleCell: UILabel!
    @IBOutlet weak var ImageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with operation: TransactionOperations) {
        
        TitleCell.text = operation.nameOperation
        ImageCell.image = operation.iconOperation
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
