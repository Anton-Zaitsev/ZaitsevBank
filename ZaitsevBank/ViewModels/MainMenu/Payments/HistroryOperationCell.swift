//
//  HistroryOperationCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.04.2022.
//

import Foundation
import UIKit

class HistoryOperationCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageHistory: UIImageView!
    
    @IBOutlet weak var NameHistory: UILabel!
    
    @IBOutlet weak var ButtonDeleteHistory: UIButton!
    
    @IBOutlet weak var ViewHistory: UIView!
    
    func configurated(with histrory: HistoryOperationPayments) {
        
        ViewHistory.layer.cornerRadius = 15
        ViewHistory.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        
        NameHistory.text = histrory.nameOperation
        ImageHistory.image = histrory.iconOperation
    }
}


