//
//  CardChoiceController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 26.04.2022.
//

import UIKit


protocol CardChoiseDelegate: AnyObject {
    func CardPick(Cards: [Cards]?,indexPickCard: Int?)
}

class CardChoiceController: UIViewController {

    
    @IBOutlet weak var AddNewCard: UIStackView!
    
    @IBOutlet weak var CardTable: UITableView!
    
    public var cardUser : [Cards] =  [Cards]()
    
    weak var delegate: CardChoiseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loader = self.EnableLoader(CGRect(x: 0, y: UIScreen.main.bounds.height / 1.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 ))
        if(cardUser.isEmpty){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
                Task{
                    cardUser = await CardsManager().GetAllCards()
                    
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
    
    private func getView() {
        CardTable.delegate = self
        CardTable.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddNewCardFunction))
        AddNewCard.isUserInteractionEnabled = true
        AddNewCard.addGestureRecognizer(tap)
    }
    @objc private func AddNewCardFunction(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        delegate?.CardPick(Cards: nil,indexPickCard: nil)
    }
}

extension CardChoiceController: UITableViewDelegate, UITableViewDataSource {
    
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
