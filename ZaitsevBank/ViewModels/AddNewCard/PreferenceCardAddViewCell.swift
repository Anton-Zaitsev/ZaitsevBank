//
//  PreferenceCardAddViewCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.11.2021.
//

import UIKit

class PreferenceCardAddViewCell: UITableViewCell {

    @IBOutlet weak var IconPerformance: UIImageView!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    @IBOutlet weak var SubLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with preference: CardAddPerformance) {
        IconPerformance.image = UIImage(systemName: preference.image)
        MainLabel.text = preference.mainLabel
        SubLabel.text = preference.label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
