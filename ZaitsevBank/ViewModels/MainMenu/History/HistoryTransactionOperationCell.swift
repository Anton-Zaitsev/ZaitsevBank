//
//  HistoryTransactionOperationCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import UIKit

class HistoryTransactionOperationCell: UICollectionViewCell {
    
    @IBOutlet weak var ViewHistory: UIView!
    @IBOutlet weak var ImageHistory: UIImageView!
    @IBOutlet weak var NameHistory: UILabel!
    
    
    func configurated(with histrory: HistoryTransactionModel) {
                
        ViewHistory.layer.cornerRadius = 15
        ViewHistory.backgroundColor = UIColor("#2F2F2F")!.withAlphaComponent(0.3)
        
        NameHistory.text = histrory.NameOperation
        ImageHistory.image = histrory.ImageOperation
    }
    
}
