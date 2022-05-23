//
//  StartMainController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.10.2021.
//

import UIKit



class StartMainController: UIViewController {
    
    private let modelStartMain : StartMenu = StartMenu()
    private let accountManager : AccountManager = AccountManager()
    private let cardManager : CardsManager = CardsManager()
    
    private var ExhangeTableValute = true
    
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelValute: UILabel!
    @IBOutlet weak var CollectionOffers: UICollectionView!
    
    
    @IBOutlet weak var AllExchange: UILabel!
    
    @IBOutlet weak var MonthlyExpenses: UILabel!
    @IBOutlet weak var IndicatorMonthlyExpenses: LineView!
    @IBOutlet weak var ViewMonthlyExpenses: UIView!
    
    @IBOutlet weak var WalletView: UIView!
    @IBOutlet weak var WalletTable: UITableView!
    
    @IBOutlet weak var ScrollViewStartMainController: UIScrollView!
    
    @IBOutlet weak var ButtonValute: UIButton!
    @IBOutlet weak var ButtonCriptoValute: UIButton!
    
    @IBOutlet weak var ExchangeView: UIView!
    @IBOutlet weak var ExchangeTable: UITableView!
    
    @IBOutlet weak var LabelFullAddCard: UILabel!
    @IBOutlet weak var LabelAddCard: UIButton!
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor("#141425")!.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.5]
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true;
        GetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LabelFullAddCard.textColor = #colorLiteral(red: 0, green: 0.6389579177, blue: 0, alpha: 1)
        AllExchange.textColor = #colorLiteral(red: 0, green: 0.6389579177, blue: 0, alpha: 1)
    }
        
    private func GetView() {
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        LabelName.text = ""
        LabelFullAddCard.isEnabled = false
        LabelAddCard.isEnabled = false
        
        CollectionOffers.delegate = self
        CollectionOffers.dataSource = self
 
        IndicatorMonthlyExpenses.colors = [
            UIColor(red: 1.0, green: 31.0/255.0, blue: 73.0/255.0, alpha: 1.0), // red
            UIColor(red:1.0, green: 138.0/255.0, blue: 0.0, alpha:1.0), // orange
            UIColor(red: 122.0/255.0, green: 108.0/255.0, blue: 1.0, alpha: 1.0), // purple
            UIColor(red: 0.0, green: 100.0/255.0, blue: 1.0, alpha: 1.0), // dark blue
            UIColor(red: 100.0/255.0, green: 241.0/255.0, blue: 183.0/255.0, alpha: 1.0), // green
            UIColor(red: 0.0, green: 222.0/255.0, blue: 1.0, alpha: 1.0) // blue
        ]
        IndicatorMonthlyExpenses.values = [0.15, 0.1, 0.35, 0.15, 0.1, 0.15]
        
        
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
        
        _ = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(getDataStartMenu), userInfo: nil, repeats: false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddNewCard))
        LabelFullAddCard.isUserInteractionEnabled = true
        LabelFullAddCard.addGestureRecognizer(tap)
        
        let tapAllCurse = UITapGestureRecognizer(target: self, action: #selector(SeeAllExchange))
        AllExchange.isUserInteractionEnabled = true
        AllExchange.addGestureRecognizer(tapAllCurse)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        ScrollViewStartMainController.refreshControl = refreshControl
        
        WalletTable.delegate = self
        WalletTable.dataSource = self
        
        ExchangeTable.delegate = self
        ExchangeTable.dataSource = self
        
    }
    
    @objc private func getDataStartMenu() {
        DispatchQueue.main.async { [self] in
            let loaderView = EnableLoader()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            await self.getDataUserTable()
                        }
                        group.addTask {
                            await self.getValuteExchange()
                        }
                        group.addTask {
                            await self.getTableWallet()
                        }
                        group.addTask {
                            self.modelStartMain.dataBitExchange = await API_VALUTE.getBitcoinTable()
                        }
                    }
                }
            }
            DisableLoader(loader: loaderView)
        }
        var count = 0
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] (_) in
            if (modelStartMain.dataValute.count > 0){
                LabelValute.fadeTransition(0.4)
                if (count == modelStartMain.dataValute.count){
                    LabelValute.text = "Добро пожаловать в Zaitsev Банк"
                }
                else {
                    let text = "\(modelStartMain.dataValute[count].nameValute): \(modelStartMain.dataValute[count].countValute) \(modelStartMain.dataValute[count].changes)"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                    attributedString.setColor(color: modelStartMain.dataValute[count].ValuePlus ? .green : .red, forText: "\(modelStartMain.dataValute[count].changes)")
                    LabelValute.attributedText = attributedString
                }
                count = count == modelStartMain.dataValute.count ? 0 : count + 1
            }
            else {
                LabelValute.text = "Добро пожаловать в Zaitsev Банк"
            }
        }
    }
    
    @objc private func SeeAllExchange(sender: UITapGestureRecognizer) {
        AllExchange.textColor = .white
        let storyboardValuteMenuMenu : UIStoryboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
        let ExhangeRate = storyboardValuteMenuMenu.instantiateViewController(withIdentifier: "ExhangeAllValute") as! ExchangeRateController
        navigationController?.isNavigationBarHidden = false;
        self.navigationController?.pushViewController(ExhangeRate, animated: true)
    }
    
    @objc private func AddNewCard(sender: UITapGestureRecognizer) {
        LabelFullAddCard.textColor = .white
        AddNewCardFunction(OwnerNameFamily: "\(modelStartMain.DataUser.firstName) \(modelStartMain.DataUser.lastName)")
    }
    
    
    @objc private func refreshAllData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await self.getDataUserTable()
                    }
                    group.addTask {
                        await self.getValuteExchange()
                    }
                    group.addTask {
                        await self.getTableWallet()
                    }
                    group.addTask {
                        self.modelStartMain.dataBitExchange = await API_VALUTE.getBitcoinTable()
                    }
                }
                DispatchQueue.main.async {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @IBAction func NewCardPlus(_ sender: Any) {
        AddNewCardFunction(OwnerNameFamily: "\(modelStartMain.DataUser.firstName) \(modelStartMain.DataUser.lastName)")
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
                        self.ExchangeTable.reloadData()
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
                        self.ExchangeTable.reloadData()
                    }
                }
            }
        }
    }
    
    private func AddNewCardFunction(OwnerNameFamily: String) {
        navigationController?.isNavigationBarHidden = false;
        let AddNewCardController = storyboard?.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
        AddNewCardController.nameFamilyOwner = OwnerNameFamily
        self.navigationController?.pushViewController(AddNewCardController, animated: true)
    }
    
    private func getValuteExchange() async {
        
        let data : ([ValuteMainLabel], [Exchange]) = await API_VALUTE.getDataValute()
        modelStartMain.dataValute = data.0
        modelStartMain.dataExchange = data.1
        modelStartMain.dataTableExchange.removeAll()
        
        if (modelStartMain.dataExchange.count > 0) {
            modelStartMain.dataTableExchange.removeAll()
        }
        
        if let dataUSD = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.USD.rawValue}) {
            modelStartMain.dataTableExchange.append(dataUSD)
        }
        
        if let dataEvro = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.EUR.rawValue}) {
            modelStartMain.dataTableExchange.append(dataEvro)
        }
        
        if let dataUKR = modelStartMain.dataExchange.first(where:{$0.typeValuteExtended == ValuteType.UAH.rawValue}) {
            modelStartMain.dataTableExchange.append(dataUKR)
        }
        
        ExhangeTableValute = true
        
        DispatchQueue.main.async {
            self.ButtonValute.backgroundColor = .white
            self.ButtonValute.setTitleColor(.black, for: .normal)
            self.ButtonCriptoValute.backgroundColor = #colorLiteral(red: 0.2114904225, green: 0.2115325928, blue: 0.2114848793, alpha: 1)
            self.ButtonCriptoValute.setTitleColor(.white, for: .normal)
            
            self.ExchangeTable.reloadData()
        }
    }
    
    private func getTableWallet() async{
        modelStartMain.cardUser = await cardManager.GetAllCards()
        DispatchQueue.main.async {
            self.WalletTable.reloadData()
        }
    }
    
    private func getDataUserTable() async {
        if let dataUser = await accountManager.GetUserData(){
            modelStartMain.DataUser = dataUser
            DispatchQueue.main.async {
                self.LabelFullAddCard.isEnabled = true
                self.LabelAddCard.isEnabled = true
                self.LabelName.text = dataUser.firstName
            }
        }
        else {
            DispatchQueue.main.async {
                self.LabelName.text = "НЕ НАЙДЕН"
            }
        }
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
            return modelStartMain.cardUser.count
        case ExchangeTable :
            return modelStartMain.dataTableExchange.count
        default:
            return modelStartMain.cardUser.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch tableView {
        case WalletTable:
            if let WalletCell = tableView.dequeueReusableCell(withIdentifier: "cellWalet", for: indexPath) as? WalletViewCell {
                WalletCell.configurated(with: (self.modelStartMain.cardUser[indexPath.row]))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == WalletTable){
            tableView.deselectRow(at: indexPath, animated: true)
            
            let storyboardCardViewer : UIStoryboard = UIStoryboard(name: "CardViewer", bundle: nil)
            let CardViewer = storyboardCardViewer.instantiateViewController(withIdentifier: "CardView") as! FullCardController
            
            CardViewer.cardFull = modelStartMain.cardUser
            CardViewer.indexCard = indexPath
            navigationController?.isNavigationBarHidden = false;
            
            self.navigationController?.pushViewController(CardViewer, animated: true)
        }
    }
    
}




