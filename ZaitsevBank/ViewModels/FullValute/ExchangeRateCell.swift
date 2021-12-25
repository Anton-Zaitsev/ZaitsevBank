//
//  ExchangeRateCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit


class ExchangeRateCell: UITableViewCell {

    
    @IBOutlet weak var CharCode: UILabel!
    @IBOutlet weak var NameValute: UILabel!
    
    @IBOutlet weak var ChangesBuy: UIImageView!
    @IBOutlet weak var LabelBuy: UILabel!
    
    @IBOutlet weak var CharView: Chart!
    
    @IBOutlet weak var ChangesSale: UIImageView!
    @IBOutlet weak var LabelSale: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurated(with valute: ExchangeFull) {
        
        if (CharView.series.isEmpty){
            let series = ChartSeries(valute.dataChar.value)
            
            series.colors = (
              above: ChartColors.greenColor(),
              below: ChartColors.redColor(),
              zeroLevel: valute.dataChar.now
            )
            
            CharView.add(series)
        }
        CharView.gridColor = .clear
        CharView.showXLabelsAndGrid = false
        CharView.showYLabelsAndGrid = false
        CharView.topInset = 0
        CharView.bottomInset = 0
        CharView.axesColor = .clear
        
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
                
        ChangesSale.image = UIImage(systemName: valute.changesSale ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(valute.changesSale ? .green : .red)
        LabelSale.text = valute.sale
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
