//
//  OffersViewCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.10.2021.
//

import UIKit

class OffersViewCell: UICollectionViewCell {
    
    @IBOutlet weak private  var LabelCell: UILabel!
    @IBOutlet weak private var ImageCell: UIImageView!
    @IBOutlet weak var ViewCell: UIView!
    
    func configurated(with NameOffers: String, with ImageOffers: String) {
        ViewCell.layer.cornerRadius = 15
        ViewCell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        LabelCell.numberOfLines = 0
        LabelCell.text = NameOffers
        ImageCell.image = UIImage(systemName: ImageOffers, withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
    }
}
