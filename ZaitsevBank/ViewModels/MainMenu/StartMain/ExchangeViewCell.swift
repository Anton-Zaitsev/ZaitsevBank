//
//  ExchangeViewCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 03.11.2021.
//

import UIKit

class ExchangeViewCell: UITableViewCell {

    @IBOutlet weak var ViewTypeValute: UIView!
    @IBOutlet weak var TypeValute: UILabel!
    
    @IBOutlet weak var NameValute: UILabel!
    @IBOutlet weak var TypeValuteLabel: UILabel!
    
    @IBOutlet weak var BuyLabel: UILabel!
    @IBOutlet weak var ChartBuy: UIImageView!
    
    
    @IBOutlet weak var SaleLabel: UILabel!
    @IBOutlet weak var ChartSale: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewTypeValute.layer.cornerRadius = ViewTypeValute.frame.height / 2

        let colorTop =  UIColor(red: Double(Int.random(in: 0..<255))/255.0, green: Double(Int.random(in: 0..<255))/255.0, blue: Double(Int.random(in: 0..<255))/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 81.0/255.0, green: 45.0/255.0, blue: 168.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = ViewTypeValute.bounds
        gradientLayer.cornerRadius = ViewTypeValute.frame.height / 2
        ViewTypeValute.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func configurated(with change: Exchange) {
        TypeValute.text = change.typeValute
        NameValute.text = change.nameValute
        TypeValuteLabel.text = change.typeValuteExtended
        BuyLabel.text = change.buyValute
        ChartBuy.image = UIImage(systemName: change.chartBuy ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(change.chartBuy ? .green : .red)
        SaleLabel.text = change.saleValute
        ChartSale.image = UIImage(systemName: change.chartSale ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(change.chartSale ? .green : .red)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
