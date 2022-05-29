//
//  CreditPayController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 28.05.2022.
//

import UIKit

class CreditPayController: UIViewController,CardPickDelegate {
    
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        if let cards = Cards {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task(priority: .high) {
                    
                    if await transactionManager.AddMoneyCredit(transactionCredit: pickTransactionID!, transactionCard: cards[indexPickCard!].transactionID , creditID: pickCreditID!) {
                        DispatchQueue.main.async { [self] in
                            
                            let storyboard = UIStoryboard(name: "TransferMenu", bundle: nil)
                            let transactionTemplate = storyboard.instantiateViewController(withIdentifier: "TransactionTemplate") as! TransactionTemplateController
                            transactionTemplate.operationName = "Оплата кредита"
                            transactionTemplate.operationTitle = nameCredit
                            transactionTemplate.operationSubTitle = "Кредит успешно оплачен"
                            navigationController?.pushViewController(transactionTemplate, animated: true)
                            
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось оплатить кредит")
                        }
                    }
                    
                }
            }
        }
        else {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                Task(priority: .medium) {
                    
                    if let data = await AccountManager().GetUserData(){
                        DispatchQueue.main.async {
                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                            AddNewCardController.nameFamilyOwner = "\(data.firstName) \(data.lastName)"
                            
                            AddNewCardController.ValutePick = self.valute.rawValue
                            self.DisableLoader(loader: loader)
                            self.navigationController?.pushViewController(AddNewCardController, animated: true)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о пользователе")
                        }
                    }
                    
                }
            }
        }
    }
    
    private let imagesGif : [UIImage]? = {
        guard let path = Bundle.main.path(forResource: "TransactionGif", ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil  }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }()
    
    @IBOutlet weak var ViewTable: UIView!
    
    @IBOutlet weak var CreditsTable: UITableView!
    
    @IBOutlet weak var StackErrorFind: UIStackView!
    
    @IBOutlet weak var LabelError: UILabel!
    
    @IBOutlet weak var LoaderCredits: UIImageView!
    
    private var Credits : [SortedAllCreditList] = []
    private let transactionManager : TransactionManager  = TransactionManager()
    private let valute : ValuteZaitsevBank = ValuteZaitsevBank.RUB
    
    private var pickCreditID : String?
    private var pickTransactionID : String?
    private var nameCredit : String?
    
    private var typeCredits = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewTable.roundTopCorners(radius: 20)

        LoaderCredits.clipsToBounds = true
        LoaderCredits.isHidden = false
        StackErrorFind.isHidden = true
        LoaderCredits.isHidden = true
        
        ViewTable.backgroundColor = UIColor("#291836")
        
        CreditsTable.delegate = self
        CreditsTable.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCredits), for: .valueChanged)
        CreditsTable.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.isNavigationBarHidden = false;
        if Credits.isEmpty{
            GetAllCredit()
        }
    }
    
    @objc private func refreshCredits(refreshControl: UIRefreshControl) {
        
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                if let allCredits = await transactionManager.GetListCredits(allList: typeCredits){
                    Credits = allCredits
                    DispatchQueue.main.async { [self] in
                        CreditsTable.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
                else {
                    DispatchQueue.main.async{ [self] in
                        refreshControl.endRefreshing()
                        LabelError.text = typeCredits ? "Не найдены платежи по кредитам, попробуйте обновить." : "Ожидающие платежи по кредитам не были найдены, попробуйте обновить."
                        StackErrorFind.isHidden = false
                    }
                }
            }
        }
    }
    
    private func GetAllCredit() {
        StackErrorFind.isHidden = true
        CreditsTable.isHidden = true
        ViewTable.backgroundColor = UIColor("#291836")
        
        LoaderCredits.isHidden = false
        if (imagesGif != nil){
            LoaderCredits.animationImages = imagesGif
            LoaderCredits.startAnimating()
        }
        else {
            LoaderCredits.image = UIImage(named: "TransactionGif.gif")
        }
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                if let allCredits = await transactionManager.GetListCredits(allList: typeCredits){
                    Credits = allCredits
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        
                        UIView.animate(withDuration: 0.55,
                                       animations: { [self] in
                            LoaderCredits.stopAnimating()
                            LoaderCredits.isHidden = true
                            ViewTable.backgroundColor = UIColor("#1E1E1E")
                            CreditsTable.isHidden = false
                            CreditsTable.reloadData()
                            
                            if (Credits.isEmpty == false){
                                let indexPath = IndexPath(row: 0, section: 0)
                                CreditsTable.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        })
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                        UIView.animate(withDuration: 0.55,
                                       animations: { [self] in
                            LoaderCredits.stopAnimating()
                            LoaderCredits.isHidden = true
                            ViewTable.backgroundColor = UIColor("#1E1E1E")
                            LabelError.text = typeCredits ? "Не найдены платежи по кредитам, попробуйте обновить." : "Ожидающие платежи по кредитам не были найдены, попробуйте обновить."
                            StackErrorFind.isHidden = false
                        })
                    }
                }
            }
        }
        
    }
    @IBAction func ControllerCreditsTable(_ sender: UISegmentedControl) {
        Credits.removeAll()
        CreditsTable.reloadData()
        
        switch sender.selectedSegmentIndex {
        case 0:
            typeCredits = false
            GetAllCredit()
        case 1:
            typeCredits = true
            GetAllCredit()
        default:
            typeCredits = false
            GetAllCredit()
            return
        }
    }
    @IBAction func UpdateButton(_ sender: Any) {
        GetAllCredit()
    }
}
extension CreditPayController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Credits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Credits[section].credits.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Credits[section].SettingsCredit.nameCredit
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let CreditPayInfoCell = tableView.dequeueReusableCell(withIdentifier: "creditPayCell", for: indexPath) as? CreditPayInfoCell {
            CreditPayInfoCell.configurated(with: Credits[indexPath.section].credits[indexPath.row],with: valute)
            cell = CreditPayInfoCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (Credits[indexPath.section].credits[indexPath.row].waiting || Credits[indexPath.section].credits[indexPath.row].overdue) {
            
            nameCredit = Credits[indexPath.section].SettingsCredit.nameCredit
            pickCreditID = Credits[indexPath.section].SettingsCredit.creditID
            pickTransactionID = Credits[indexPath.section].credits[indexPath.row].idTransaction
            
            let storyboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
            let CardPick = storyboard.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
            CardPick.textMainLable = "оплаты кредита."
            CardPick.valuteSymbol = valute.rawValue
            CardPick.buySaleToogle = false // Только покупка, чтобы найти рублевые карты
            CardPick.delegate = self
            CardPick.sheetPresentationController?.detents = [.medium()]
            present(CardPick, animated: true)
        }
        
    }
    
}
