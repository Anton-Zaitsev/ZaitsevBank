//
//  CalculationCreditCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 28.05.2022.
//

import UIKit

class CalculationCreditCell: UITableViewCell {

    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var PaymentLabel: UILabel!
    
    @IBOutlet weak var Persent: UILabel!
    
    @IBOutlet weak var Remains: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configurated(with credit: PaymentsCredit, with valute: ValuteZaitsevBank) {
        var DateNow = Date.now
        let calendar = Calendar.current
        DateNow = calendar.date(byAdding: .month, value: credit.month, to: DateNow)!
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MMMM, yyyy"
        
        MonthLabel.text = dateformat.string(from: DateNow)
        PaymentLabel.text = "\(credit.pay.valuteToTableFormat()) \(valute.description)"
        Persent.text = "\(credit.percents.valuteToTableFormat()) \(valute.description)"
        Remains.text = "\(credit.lastSumm.valuteToTableFormat()) \(valute.description)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
