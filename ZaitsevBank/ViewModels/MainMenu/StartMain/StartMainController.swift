//
//  StartMainController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.10.2021.
//

import UIKit



class StartMainController: UIViewController {
    
    private let modelStartMain : StartMenu = StartMenu()
    
    public var dataUser = clientZaitsevBank()
    public var cardUser = [Cards]()
    
    fileprivate let dataValute = API.getDataValute()
    
    fileprivate var ExhangeTableValute = true
    
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelValute: UILabel!
    @IBOutlet weak var CollectionOffers: UICollectionView!
    
    @IBOutlet weak var LabelAddNewCard: UILabel!
    
    @IBOutlet weak var AllExchange: UILabel!
    
    @IBOutlet weak var MonthlyExpenses: UILabel!
    @IBOutlet weak var IndicatorMonthlyExpenses: UIView!
    @IBOutlet weak var ViewMonthlyExpenses: UIView!
    
    @IBOutlet weak var WalletView: UIView!
    @IBOutlet weak var WalletTable: UITableView!
    
    @IBOutlet weak var ScrollViewStartMainController: UIScrollView!
    
    @IBOutlet weak var ButtonValute: UIButton!
    @IBOutlet weak var ButtonCriptoValute: UIButton!
    
    @IBOutlet weak var ExchangeView: UIView!
    @IBOutlet weak var ExchangeTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true;
        GetView()
    }
    
    
    fileprivate func GetView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddNewCard))
        LabelAddNewCard.isUserInteractionEnabled = true
        LabelAddNewCard.addGestureRecognizer(tap)
        
        let tapAllCurse = UITapGestureRecognizer(target: self, action: #selector(SeeAllExchange))
        AllExchange.isUserInteractionEnabled = true
        AllExchange.addGestureRecognizer(tapAllCurse)
        
        LabelName.text = dataUser.name
        CollectionOffers.delegate = self
        CollectionOffers.dataSource = self
        IndicatorMonthlyExpenses.layer.cornerRadius = IndicatorMonthlyExpenses.frame.height / 2
        
        ViewMonthlyExpenses.layer.cornerRadius = 6
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"
        MonthlyExpenses.text! += dateFormatter.string(from: Date())
        
        WalletView.layer.cornerRadius = 12
        ExchangeView.layer.cornerRadius = 12
        
        ButtonValute.layer.cornerRadius = ButtonValute.frame.height / 2
        ButtonCriptoValute.layer.cornerRadius = ButtonCriptoValute.frame.height / 2
        ButtonValute.backgroundColor = .white
        ButtonValute.setTitleColor(.black, for: .normal)
        ButtonCriptoValute.backgroundColor = #colorLiteral(red: 0.2114904225, green: 0.2115325928, blue: 0.2114848793, alpha: 1)
        ButtonCriptoValute.setTitleColor(.white, for: .normal)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        ScrollViewStartMainController.refreshControl = refreshControl
        
        WalletTable.delegate = self
        WalletTable.dataSource = self
        
        ExchangeTable.delegate = self
        ExchangeTable.dataSource = self
        
    }
    
    @objc fileprivate func SeeAllExchange(sender: UITapGestureRecognizer) {
        AllExchange.textColor = .white
        let storyboardValuteMenuMenu : UIStoryboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
        let ExhangeRate = storyboardValuteMenuMenu.instantiateViewController(withIdentifier: "ExhangeAllValute") as! ExchangeRateController
        self.navigationController?.pushViewController(ExhangeRate, animated: true)
    }
    
    @objc fileprivate func AddNewCard(sender: UITapGestureRecognizer) {
        LabelAddNewCard.textColor = .white
        AddNewCardFunction(OwnerNameFamily: "\(dataUser.name!) \(dataUser.family!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true;
        // -- GET CARD USER
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                cardUser = await GetCardUser().getCards()
                modelStartMain.dataExchange = await API.getValuteTable()
                
                modelStartMain.dataTableExchange.removeAll()
                
                if let dataUSD = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.USD.rawValue}) {
                    modelStartMain.dataTableExchange.append(dataUSD)
                }
                
                if let dataEvro = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.EUR.rawValue}) {
                    modelStartMain.dataTableExchange.append(dataEvro)
                }
                
                if let dataUKR = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.UAH.rawValue}) {
                    modelStartMain.dataTableExchange.append(dataUKR)
                }
                
                DispatchQueue.main.async {
                    WalletTable.reloadData()
                    print("Итого в массиве \(modelStartMain.dataExchange.count)")
                    ExchangeTable.reloadData()
                }
                
                modelStartMain.dataBitExchange = await API.getBitcoinTable()
            }
        }
        
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] (_) in
            LabelValute.fadeTransition(0.4)
            if (count == dataValute.count){
                LabelValute.text = "Добро пожаловать в Zaitsev Банк"
            }
            else {
                let text = "\(dataValute[count].nameValute): \(dataValute[count].countValute) \(dataValute[count].changes)"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributedString.setColor(color: dataValute[count].ValuePlus ? .green : .red, forText: "\(dataValute[count].changes)")
                LabelValute.attributedText = attributedString
            }
            count = count == dataValute.count ? 0 : count + 1
            
        }
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
        LabelAddNewCard.textColor = #colorLiteral(red: 0, green: 0.6389579177, blue: 0, alpha: 1)
        AllExchange.textColor = #colorLiteral(red: 0, green: 0.6389579177, blue: 0, alpha: 1)
    }
    
    @objc fileprivate func refreshAllData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                cardUser = await GetCardUser().getCards()
                modelStartMain.dataExchange = await API.getValuteTable()
            
            
                if (modelStartMain.dataExchange.count > 0) {
                    modelStartMain.dataTableExchange.removeAll()
                    
                    if let dataUSD = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.USD.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataUSD)
                    }
                    
                    if let dataEvro = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.EUR.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataEvro)
                    }
                    
                    if let dataUKR = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.UAH.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataUKR)
                    }
                }
                
                ExhangeTableValute = true
                
                DispatchQueue.main.async {
                    ButtonValute.backgroundColor = .white
                    ButtonValute.setTitleColor(.black, for: .normal)
                    ButtonCriptoValute.backgroundColor = #colorLiteral(red: 0.2114904225, green: 0.2115325928, blue: 0.2114848793, alpha: 1)
                    ButtonCriptoValute.setTitleColor(.white, for: .normal)
                    
                    WalletTable.reloadData()
                    ExchangeTable.reloadData()
                }
                
                modelStartMain.dataBitExchange  = await API.getBitcoinTable()
            }
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func NewCardPlus(_ sender: Any) {
        AddNewCardFunction(OwnerNameFamily: "\(dataUser.name!) \(dataUser.family!)")
    }
    
    
    @IBAction func SeeBitValute(_ sender: Any) {
        
        if(ExhangeTableValute){
            ExhangeTableValute.toggle()
            ButtonValute.backgroundColor = #colorLiteral(red: 0.2114904225, green: 0.2115325928, blue: 0.2114848793, alpha: 1)
            ButtonValute.setTitleColor(.white, for: .normal)
            ButtonCriptoValute.backgroundColor = .white
            ButtonCriptoValute.setTitleColor(.black, for: .normal)
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    modelStartMain.dataTableExchange.removeAll()
                    modelStartMain.dataTableExchange = modelStartMain.dataBitExchange
                    
                    DispatchQueue.main.async {
                        ExchangeTable.reloadData()
                    }
                }
            }
        }
    }
    @IBAction func SeeValute(_ sender: Any) {
        
        if (!ExhangeTableValute){
            ExhangeTableValute.toggle()
            ButtonValute.backgroundColor = .white
            ButtonValute.setTitleColor(.black, for: .normal)
            ButtonCriptoValute.backgroundColor = #colorLiteral(red: 0.2114904225, green: 0.2115325928, blue: 0.2114848793, alpha: 1)
            ButtonCriptoValute.setTitleColor(.white, for: .normal)
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    modelStartMain.dataTableExchange.removeAll()
                    
                    if let dataUSD = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.USD.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataUSD)
                    }
                    
                    if let dataEvro = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.EUR.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataEvro)
                    }
                    
                    if let dataUKR = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.UAH.rawValue}) {
                        modelStartMain.dataTableExchange.append(dataUKR)
                    }
                    
                    DispatchQueue.main.async {
                        ExchangeTable.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func AddNewCardFunction(OwnerNameFamily: String) {
        let AddNewCardController = storyboard?.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
        AddNewCardController.nameFamilyOwner = OwnerNameFamily
        self.navigationController?.pushViewController(AddNewCardController, animated: true)
    }
}

extension StartMainController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelStartMain.dataOffers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let OffersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "offers", for: indexPath) as? OffersViewCell {
            OffersCell.configurated(with: self.modelStartMain.dataOffers[indexPath.row].title , with: self.modelStartMain.dataOffers[indexPath.row].backgroundImage)
            cell = OffersCell
        }
        return cell
    }
}

extension StartMainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView{
        case WalletTable :
            return cardUser.count
        case ExchangeTable :
            return modelStartMain.dataTableExchange.count
        default:
            return cardUser.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch tableView {
        case WalletTable:
            if let WalletCell = tableView.dequeueReusableCell(withIdentifier: "cellWalet", for: indexPath) as? WalletViewCell {
                WalletCell.configurated(with: (self.cardUser[indexPath.row]))
                cell = WalletCell
            }
            return cell
        case ExchangeTable:
            if let ExchangeCell = tableView.dequeueReusableCell(withIdentifier: "cellExchange", for: indexPath) as? ExchangeViewCell {
                ExchangeCell.configurated(with: (self.modelStartMain.dataTableExchange[indexPath.row]))
                cell = ExchangeCell
            }
            return cell
        default:
            return cell
        }
    }
    
}



