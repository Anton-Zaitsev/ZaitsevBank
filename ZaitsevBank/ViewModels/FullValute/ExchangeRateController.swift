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
        dataExchange.exchangeValuteDefault.removeAll()
        switch sender.selectedSegmentIndex {
        case 0:
            if (dataExchange.exchangeValute.isEmpty){
                ExchangeTable.reloadData()
                let loader = self.EnableLoader()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                    Task{
                        dataExchange.exchangeValute = await API.getValuteTableFull()
                        dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
                        DispatchQueue.main.async {
                            ExchangeTable.reloadData()
                            self.DisableLoader(loader: loader)
                            if (!dataExchange.exchangeValuteDefault.isEmpty){
                                let indexPath = IndexPath(row: 0, section: 0)
                                ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
            else {
                dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
                ExchangeTable.reloadData()
                if (!dataExchange.exchangeValuteDefault.isEmpty){
                    let indexPath = IndexPath(row: 0, section: 0)
                    ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            valuteToogle = true
            
        case 1:
            if (dataExchange.exchangeValuteCriptoValute.isEmpty){
                ExchangeTable.reloadData()
                let loader = self.EnableLoader()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                    Task{
                        dataExchange.exchangeValuteCriptoValute = await API.getBitcoinTableFull()
                        dataExchange.exchangeValuteDefault = dataExchange.exchangeValuteCriptoValute
                        DispatchQueue.main.async {
                            ExchangeTable.reloadData()
                            self.DisableLoader(loader: loader)
                            if (!dataExchange.exchangeValuteDefault.isEmpty){
                                let indexPath = IndexPath(row: 0, section: 0)
                                ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
            else {
                dataExchange.exchangeValuteDefault = dataExchange.exchangeValuteCriptoValute
                ExchangeTable.reloadData()
                if (!dataExchange.exchangeValuteDefault.isEmpty){
                    let indexPath = IndexPath(row: 0, section: 0)
                    ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
        
        return dataExchange.exchangeValuteDefault.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if let ExchangeRateCell = tableView.dequeueReusableCell(withIdentifier: "exchange", for: indexPath) as? ExchangeRateCell {
            ExchangeRateCell.configurated(with: self.dataExchange.exchangeValuteDefault[indexPath.row])
            cell = ExchangeRateCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idValute = dataExchange.exchangeValuteDefault[indexPath.row].IDValute
        let nameValute = dataExchange.exchangeValuteDefault[indexPath.row].nameValute
        let symbolValute = dataExchange.exchangeValuteDefault[indexPath.row].charCode
        
        let loader = self.EnableLoader()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ChartValute = self.storyboard?.instantiateViewController(withIdentifier: "ChartValute") as! ChartValuteController
        
        ChartValute.valuteSymbol = symbolValute
        ChartValute.valuteName = nameValute
        ChartValute.dinamicValute = dataExchange.exchangeValuteDefault[indexPath.row].dataChar
        ChartValute.idValute = idValute
        ChartValute.valuteToogle = self.valuteToogle
        self.DisableLoader(loader: loader)
        self.navigationController?.pushViewController(ChartValute, animated: true)
        
    }
    
}

