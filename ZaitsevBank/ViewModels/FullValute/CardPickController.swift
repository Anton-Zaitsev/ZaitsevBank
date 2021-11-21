//
//  CardPickController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.11.2021.
//

import UIKit

class CardPickController: UIViewController {
    
    @IBOutlet weak var UpView: UIView!
    
    @IBOutlet weak var AddNewCard: UIStackView!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    public var valuteSymbol: String!
    public var textMainLable: String!
    public var buySaleToogle : Bool!
    
    
    
    @IBOutlet weak var CardTable: UITableView!
    public var cardUser : [Cards] =  [Cards]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getView()
    }
    private func getView() {
        view.layer.cornerRadius = 25
        UpView.layer.cornerRadius = UpView.layer.frame.height / 2
        MainLabel.text = textMainLable
        CardTable.delegate = self
        CardTable.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddNewCardFunction))
        AddNewCard.isUserInteractionEnabled = true
        AddNewCard.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(cardUser.isEmpty){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    cardUser = await GetCardUser().getCardsFromBuySale(valute: valuteSymbol, buySale: buySaleToogle)
                    
                    DispatchQueue.main.async {
                        if (cardUser.isEmpty){
                            CardTable.isHidden = true
                            AddNewCard.isHidden = false
                        }
                        else {
                            CardTable.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    @objc func AddNewCardFunction(sender: UITapGestureRecognizer) {

        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            Task(priority: .medium) {
                if let data = await GetDataUser().get(){
                    DispatchQueue.main.async {
                        let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                        let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                        AddNewCardController.nameFamilyOwner = "\(data.name!) \(data.family!)"
                        AddNewCardController.ValutePick = ValuteZaitsevBank(rawValue: self.valuteSymbol)?.description
                        
                        let navigationController = UINavigationController(rootViewController: AddNewCardController)
                        navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о пользователе")
                    }
                }
                
            }
            
        }
        
    }
}
extension CardPickController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let WalletCell = tableView.dequeueReusableCell(withIdentifier: "cellCard", for: indexPath) as? WalletViewCell {
            WalletCell.configurated(with: (self.cardUser[indexPath.row]))
            cell = WalletCell
        }
        return cell
    }
    
    
    
}
