//
//  ExchangeRateCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit

protocol ExchangeRateCellDelegate: AnyObject {
    func didTap(with IDExchange : String)
}

class ExchangeRateCell: UITableViewCell {

    
    @IBOutlet weak var CharCode: UILabel!
    @IBOutlet weak var NameValute: UILabel!
    
    @IBOutlet weak var ChangesBuy: UIImageView!
    @IBOutlet weak var LabelBuy: UILabel!
    @IBOutlet weak var Buy300: UILabel!
    @IBOutlet weak var Buy1000: UILabel!
    @IBOutlet weak var Buy5000: UILabel!
    
    @IBOutlet weak var ChangesSale: UIImageView!
    @IBOutlet weak var LabelSale: UILabel!
    @IBOutlet weak var Sale300: UILabel!
    @IBOutlet weak var Sale1000: UILabel!
    @IBOutlet weak var Sale5000: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with valute: ExchangeFull) {
        
        CharCode.text = valute.charCode
        
        
        if (valute.nameValute.count <= 20) {
        NameValute.text = valute.nameValute
        }
        else {
            var newValute = valute.nameValute
            while newValute.count >= 20 {
                newValute.removeLast()
                }
            newValute.append("...")
            NameValute.text = newValute
        }
            
        ChangesBuy.image = UIImage(systemName: valute.changesBuy ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(valute.changesBuy ? .green : .red)
        LabelBuy.text = valute.buy
        
        Buy300.text = valute.buy300
        Buy1000.text = valute.buy1000
        Buy5000.text = valute.buy5000
        
        ChangesSale.image = UIImage(systemName: valute.changesSale ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(valute.changesSale ? .green : .red)
        LabelSale.text = valute.sale
        Sale300.text = valute.sale300
        Sale1000.text = valute.sale1000
        Sale5000.text = valute.sale5000
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
