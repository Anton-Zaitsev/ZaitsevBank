//
//  ExchangeRateController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit

class ExchangeRateController: UIViewController {
    
    private var dataExchange : FullValuteMenu = FullValuteMenu()
    private let apiValute = API_VALUTE_FULL()
    @IBOutlet weak var MainLabel: UILabel!
    
    private var valuteToogle = true
    
    @IBOutlet weak var ExchangeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar("Курсы")
        ExchangeTable.delegate = self
        ExchangeTable.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        ExchangeTable.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (dataExchange.exchangeValuteDefault.isEmpty){
            getValute()
        }
    }
    @objc private func refreshAllData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                if (valuteToogle) {
                    dataExchange.exchangeValute = await apiValute.getValuteTableFull()
                    dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
                }
                else {
                    dataExchange.exchangeValuteCriptoValute = await apiValute.getBitcoinTableFull()
                    dataExchange.exchangeValuteDefault = dataExchange.exchangeValuteCriptoValute
                }
                DispatchQueue.main.async {
                    self.ExchangeTable.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @IBAction func ControllerExhangeTable(_ sender: UISegmentedControl) {
        dataExchange.exchangeValuteDefault.removeAll()
        ExchangeTable.reloadData()
        switch sender.selectedSegmentIndex {
        case 0:
            dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
            ExchangeTable.reloadData()
            if (dataExchange.exchangeValute.isEmpty == false){
                let indexPath = IndexPath(row: 0, section: 0)
                ExchangeTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            valuteToogle = true
        case 1:
            dataExchange.exchangeValuteDefault = dataExchange.exchangeValuteCriptoValute
            ExchangeTable.reloadData()
            if (dataExchange.exchangeValuteCriptoValute.isEmpty == false){
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
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await self.dataExchange.exchangeValute = await self.apiValute.getValuteTableFull()
                    }
                    group.addTask {
                        await self.dataExchange.exchangeValuteCriptoValute = await self.apiValute.getBitcoinTableFull()
                    }
                }
                dataExchange.exchangeValuteDefault = dataExchange.exchangeValute
                DispatchQueue.main.async {
                    self.ExchangeTable.reloadData()
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
            ExchangeRateCell.configurated(with: dataExchange.exchangeValuteDefault[indexPath.row])
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
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    Task{
                        
                        guard let data = self.valuteToogle ?
                                await API_DinamicValute().GetDinamicValute(idValute: idValute) :
                                    await API_DinamicValute().GetDinamicCriptoValute(nameValute: nameValute)
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
                            ChartValute.idValute = idValute
                            ChartValute.valuteToogle = self.valuteToogle
                            self.DisableLoader(loader: loader)
                            self.navigationController?.pushViewController(ChartValute, animated: true)
                        }
                    }
                }
    }
    
}

