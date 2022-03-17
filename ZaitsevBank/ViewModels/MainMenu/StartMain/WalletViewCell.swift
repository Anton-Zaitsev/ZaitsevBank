//
//  WalletViewCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 30.10.2021.
//

import UIKit

class WalletViewCell: UITableViewCell {

    @IBOutlet weak var NameCard: UILabel!
    @IBOutlet weak var NumberCard: UILabel!
    @IBOutlet weak var LabelMoney: UILabel!
    @IBOutlet weak var WalletTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with Card: Cards) {
        NameCard.text = Card.nameCard
        NumberCard.text = Card.numberCard
        WalletTypeImage.image = UIImage(named: Card.typeImageCard)
        
        if (Card.closed) {
            LabelMoney.text = "Карта заблокирована"
            LabelMoney.textColor = .red
        }
        else {
            LabelMoney.text = "\(Card.moneyCount) \(Card.typeMoney)"
            LabelMoney.textColor = .white
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

