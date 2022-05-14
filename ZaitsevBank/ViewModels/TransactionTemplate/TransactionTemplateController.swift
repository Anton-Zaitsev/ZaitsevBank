//
//  TransactionTemplateController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import UIKit
import AVFoundation

class TransactionTemplateController: UIViewController {

    @IBOutlet weak var SuccDown: UIView!
    @IBOutlet weak var SuccUp: UIView!
    
    @IBOutlet weak var MenuView: UIView!
    
    @IBOutlet weak var TableSettings: UITableView!
    
    @IBOutlet weak var OperationName: UILabel!
    @IBOutlet weak var OperationTitle: UILabel!
    @IBOutlet weak var OperationSubTitle: UILabel!
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor("#064433")!.cgColor,
            UIColor("#168E2F")!.cgColor
        ]
        gradient.locations = [0, 0.25]
        return gradient
    }()
    
    private let operations = TransactionTemplatesOperation().TransactionOperation
    private var player: AVAudioPlayer?
    
    public var operationName: String?
    public var operationTitle: String?
    public var operationSubTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        playSoundPay()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    private func playSoundPay() {
        //path -- MorgenTest
        guard let path = Bundle.main.path(forResource: "ZaitsevPay", ofType: "mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getView() {
        SuccDown.layer.cornerRadius = SuccDown.bounds.height / 2
        SuccDown.layer.masksToBounds = true
        
        SuccDown.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        SuccUp.layer.cornerRadius = SuccUp.bounds.height / 2
        SuccUp.layer.masksToBounds = true
        SuccUp.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        MenuView.roundTopCorners(radius: 20)
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        TableSettings.delegate = self
        TableSettings.dataSource = self
        
        if let operation_name = operationName {
            OperationName.text = operation_name
        }
        else {
            OperationName.text = "Неизвестная операция"
        }
        if let operation_title = operationTitle{
            OperationTitle.text = operation_title
        }
        else {
            OperationTitle.text = ""
        }
        if let operation_subTitle = operationSubTitle {
            OperationSubTitle.text = operation_subTitle
        }
        else {
            OperationSubTitle.text = ""
        }
    }
    @IBAction func ButtonUpClose(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        let NavigationMain = storyboard.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
        navigationController?.pushViewController(NavigationMain, animated: true)
    }
    @IBAction func ButtonGoBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        let NavigationMain = storyboard.instantiateViewController(withIdentifier: "ControllerMainMenu") as! NavigationTabBarMain
        navigationController?.pushViewController(NavigationMain, animated: true)
    }
}
extension TransactionTemplateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let SettingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? TransactionTemplateCell {
            SettingsCell.configurated(with: operations[indexPath.row])
            cell = SettingsCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        switch tableView{
        case TransferTable :
            historyPayments.OperationTransfer[indexPath.row].typeOperation.OperationPerform(self)
            break
        case PaymentTable :
            historyPayments.OperationPayment[indexPath.row].typeOperation.OperationPerform(self)
            break
        default: return
        }
        */
    }
    
}
