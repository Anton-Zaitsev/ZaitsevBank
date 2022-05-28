//
//  CalculationCreditController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 28.05.2022.
//

import UIKit

class CalculationCreditController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credit != nil ? credit!.paymentsCredits.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if (credit == nil || valute == nil) { return cell }
        if let CalculationCreditCell = tableView.dequeueReusableCell(withIdentifier: "CalculationCell", for: indexPath) as? CalculationCreditCell {
            CalculationCreditCell.configurated(with: credit!.paymentsCredits[indexPath.row], with: valute!)
            cell = CalculationCreditCell
        }
        return cell
        
    }
    
    @IBOutlet weak var Persent: UILabel!
    @IBOutlet weak var Payments: UILabel!
    
    @IBOutlet weak var ViewClose: UIView!
    
    @IBOutlet weak var TableCalculation: UITableView!
    
    public var credit : CreditCheck?
    public var valute : ValuteZaitsevBank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableCalculation.delegate = self
        TableCalculation.dataSource = self
        ViewClose.layer.cornerRadius = ViewClose.bounds.height / 2
        if (credit != nil && valute != nil){
            Persent.text = String(credit!.persent).replacingOccurrences(of: ".", with: ",") + " %"
            Payments.text = "\(Double(credit!.monthlyPayment).valuteToTableFormat()) \(valute!.description)"
        }
        else {
            Persent.text = "-"
            Payments.text = "-"
        }
    }
    
}
