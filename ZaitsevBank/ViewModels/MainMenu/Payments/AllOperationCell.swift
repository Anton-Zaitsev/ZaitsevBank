//
//  AllOperationCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 19.06.2022.
//

import UIKit

class AllOperationCell: UITableViewCell {

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
