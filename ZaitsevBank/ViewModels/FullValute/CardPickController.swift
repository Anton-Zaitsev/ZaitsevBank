//
//  CardPickController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.11.2021.
//

import UIKit

protocol CardPickDelegate: AnyObject {
    func CardPick(Cards: [Cards]?,indexPickCard: Int?)
}

class CardPickController: UIViewController {
    
    @IBOutlet weak var UpView: UIView!
    
    @IBOutlet weak var AddNewCard: UIStackView!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    public var valuteSymbol: String!
    public var textMainLable: String!
    public var buySaleToogle : Bool?
    
    weak var delegate: CardPickDelegate?
    
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
        let loader = self.EnableLoader(CGRect(x: 0, y: UIScreen.main.bounds.height / 1.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 ))
        if(cardUser.isEmpty){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    cardUser = await CardsManager().GetCardsBuySale(TypeValute: valuteSymbol, BuySale: buySaleToogle!)
                    
                    DispatchQueue.main.async { [self] in
                        if (cardUser.isEmpty){
                            CardTable.isHidden = true
                            AddNewCard.isHidden = false
                        }
                        else {
                            CardTable.reloadData()
                        }
                        DisableLoader(loader: loader)
                    }
                }
            }
        }
    }
    
    @objc func AddNewCardFunction(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        delegate?.CardPick(Cards: nil,indexPickCard: nil)
    }
}
extension CardPickController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let WalletCell = tableView.dequeueReusableCell(withIdentifier: "cellCard", for: indexPath) as? WalletViewCell {
            WalletCell.configurated(with: (cardUser[indexPath.row]))
            cell = WalletCell
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate?.CardPick(Cards: cardUser,indexPickCard: indexPath.row)
    }
    
}
