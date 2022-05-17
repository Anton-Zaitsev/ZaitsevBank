//
//  TransactionFilterOperationCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import UIKit

class TransactionFilterOperationCell: UICollectionViewCell {
    
    @IBOutlet weak var ViewOperation: UIView!
    @IBOutlet weak var NameOperation: UILabel!
    @IBOutlet weak var ImageOperation: UIImageView!
    
    func configurated(with filter: TransactionFilter) {
        ViewOperation.layer.cornerRadius = ViewOperation.bounds.height / 2
        ViewOperation.layer.masksToBounds = true
        NameOperation.text = filter.NameFilter
        
        if (filter.ClickFilter){
            ViewOperation.backgroundColor = .white
            NameOperation.textColor = UIColor("#2F2F2F")
            ImageOperation.tintColor = UIColor("#2F2F2F")
        }
        else {
            ViewOperation.backgroundColor = UIColor("#2F2F2F")
            NameOperation.textColor = .white
            ImageOperation.tintColor = .white
        }
    }
    
}
