//
//  ExchangeRateController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit

class ExchangeRateController: UIViewController {
    
    private var dataExchange : FullValuteMenu = FullValuteMenu()
    
    @IBOutlet weak var MainLabel: UILabel!
    
    public var valuteToogle = true
    
    @IBOutlet weak var ExchangeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExchangeTable.delegate = self
        ExchangeTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (dataExchange.exchangeValute.isEmpty){
            getValute()
        }
    }
    
    
    @IBAction func ControllerExhangeTable(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            dataExchange.exchangeValute.removeAll()
            dataExchange.exchangeValute = dataExchange.exchangeValuteDefault
            ExchangeTable.reloadData()
            if (!dataExchange.exchangeValuteDefault.isEmpty){
                let indexPath = IndexPath(row: 0, section: 0)
                ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            valuteToogle = true
        case 1:
            dataExchange.exchangeValute.removeAll()
            dataExchange.exchangeValute = dataExchange.exchangeValuteCriptoValute
            ExchangeTable.reloadData()
            if (!dataExchange.exchangeValuteCriptoValute.isEmpty){
                let indexPath = IndexPath(row: 0, section: 0)
                ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            valuteToogle = false
            
        default:
            valuteToogle = true
            return
        }
    }
    
    private func getValute() {
        let loader = self.EnableLoader()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                dataExchange.exchangeValute = await API.getValuteTableFull()
                dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
                dataExchange.exchangeValuteCriptoValute = await API.getBitcoinTableFull()
                DispatchQueue.main.async {
                    ExchangeTable.reloadData()
                    self.DisableLoader(loader: loader)
                }
            }
        }
    }
    
}

extension ExchangeRateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataExchange.exchangeValute.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if let ExchangeRateCell = tableView.dequeueReusableCell(withIdentifier: "exchange", for: indexPath) as? ExchangeRateCell {
            ExchangeRateCell.configurated(with: self.dataExchange.exchangeValute[indexPath.row])
            cell = ExchangeRateCell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idValute = dataExchange.exchangeValute[indexPath.row].IDValute
        let nameValute = dataExchange.exchangeValute[indexPath.row].nameValute
        let symbolValute = dataExchange.exchangeValute[indexPath.row].charCode
        
        
        let loader = self.EnableLoader()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            Task{
                
                guard let data = self.valuteToogle ?
                        await API.GetDinamicValute(idValute: idValute) :
                            await API.GetDinamicCriptoValute(nameValute: nameValute)
                else {
                    DispatchQueue.main.async {
                        self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о \(nameValute)")
                        self.DisableLoader(loader: loader)
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                    return
                }
                DispatchQueue.main.async {
                    tableView.deselectRow(at: indexPath, animated: true)
                    self.DisableLoader(loader: loader)
                    let ChartValute = self.storyboard?.instantiateViewController(withIdentifier: "ChartValute") as! ChartValuteController
                    ChartValute.valuteSymbol = symbolValute
                    ChartValute.dinamicValute = data
                    ChartValute.valuteName = nameValute
                    ChartValute.valuteToogle = self.valuteToogle
                    self.navigationController?.pushViewController(ChartValute, animated: true)
                }
            }
        }
    }
    
}

