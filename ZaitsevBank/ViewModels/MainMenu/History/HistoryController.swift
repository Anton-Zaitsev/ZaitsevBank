//
//  HistoryController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class HistoryController: UIViewController {

    private let ModelsHistory: HistoryTransactionModels = HistoryTransactionModels()
    
    private let transactionManager : TransactionManager = TransactionManager()
    
    private var transaction: [SortedAllTransaction] = []
    
    
    private lazy var imagesGif : [UIImage]? = {
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
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor("#141218")!.cgColor,
            UIColor("#141425")!.cgColor
        ]
        gradient.locations = [0, 0.25]
        return gradient
    }()
    @IBOutlet weak var LoaderTransaction: UIImageView!
    
    
    @IBOutlet weak var LabelNotTransaction: UIStackView!
    
    @IBOutlet weak var HistroryOperation: UICollectionView!
    
    @IBOutlet weak var FilterCollection: UICollectionView!
    
    @IBOutlet weak var TransactionTable: UITableView!
    
    @IBOutlet weak var ViewTransaction: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        LoaderTransaction.clipsToBounds = true
        LoaderTransaction.isHidden = false
        LabelNotTransaction.isHidden = true
        FilterCollection.isHidden = true
        TransactionTable.isHidden = true
        ViewTransaction.backgroundColor = UIColor("#291836")
        
        ViewTransaction.roundTopCorners(radius: 20)
        
        HistroryOperation.delegate = self
        HistroryOperation.dataSource = self
        
        FilterCollection.delegate = self
        FilterCollection.dataSource = self
        
        
        TransactionTable.delegate = self
        TransactionTable.dataSource = self
        TransactionTable.backgroundColor = .clear
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTransaction), for: .valueChanged)
        TransactionTable.refreshControl = refreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true;
        if transaction.isEmpty {
            updateTransaction()
        }
    }
    @objc private func refreshTransaction(refreshControl: UIRefreshControl) {
        
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                if let allTransaction = await transactionManager.GetAllTransaction(){
                    transaction = allTransaction
                    DispatchQueue.main.async { [self] in
                        TransactionTable.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
                else {
                    DispatchQueue.main.async{ [self] in
                        refreshControl.endRefreshing()
                        LabelNotTransaction.isHidden = false
                    }
                }
            }
        }
    }
    @IBAction func UpdateButton(_ sender: Any) {
        updateTransaction()
    }
    
    private func updateTransaction() {
        
        LabelNotTransaction.isHidden = true
        FilterCollection.isHidden = true
        TransactionTable.isHidden = true
        
        ViewTransaction.backgroundColor = UIColor("#291836")
        
        LoaderTransaction.isHidden = false
        if (imagesGif != nil){
            LoaderTransaction.animationImages = imagesGif
            LoaderTransaction.startAnimating()
        }
        else {
            LoaderTransaction.image = UIImage(named: "TransactionGif.gif")
        }
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                if let allTransaction = await transactionManager.GetAllTransaction(){
                    transaction = allTransaction
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        
                        UIView.animate(withDuration: 0.55,
                                       animations: { [self] in
                            LoaderTransaction.stopAnimating()
                            LoaderTransaction.isHidden = true
                            ViewTransaction.backgroundColor = UIColor("#1E1E1E")
                            FilterCollection.isHidden = false
                            TransactionTable.isHidden = false
                            TransactionTable.reloadData()
                            
                            if (transaction.isEmpty == false){
                                let indexPath = IndexPath(row: 0, section: 0)
                                TransactionTable.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        })
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        UIView.animate(withDuration: 0.55,
                                       animations: { [self] in
                        LoaderTransaction.stopAnimating()
                        LoaderTransaction.isHidden = true
                        ViewTransaction.backgroundColor = UIColor("#1E1E1E")
                        LabelNotTransaction.isHidden = false
                        })
                    }
                }
            }
        }
    }
}
extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

         //For Header Background Color
        view.tintColor = UIColor("#2F2F2F")

        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.textLabel?.textColor = .white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transaction[section].allTransactions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transaction[section].date
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        let typeOperation = AllTransactionsOperation.init(rawValue: transaction[indexPath.section].allTransactions[indexPath.row].typeTransaction)!
        
        if (typeOperation == AllTransactionsOperation.IncomingTransfer
            || typeOperation == AllTransactionsOperation.OutgoingTransfer
            || typeOperation == AllTransactionsOperation.IncomingTransferAndCurrencyTransfer
            || typeOperation == AllTransactionsOperation.OutgoingTransferAndCurrencyTransfer
            || typeOperation == AllTransactionsOperation.TakeCredit ){
            
            if let InOutcomingCell = tableView.dequeueReusableCell(withIdentifier: "InOutcomingCell", for: indexPath) as? InOutcomingCell {
                InOutcomingCell.configurated(with: transaction[indexPath.section].allTransactions[indexPath.row], with: typeOperation)
                //TransferCell.configurated(with: historyPayments.OperationTransfer[indexPath.row])
                cell = InOutcomingCell
            }
        }
        else if (typeOperation == AllTransactionsOperation.BetweenMyCards || typeOperation == AllTransactionsOperation.BetweenMyCardsAndCurrencyTransfer){
            
            if let BetweenMyCardsCell = tableView.dequeueReusableCell(withIdentifier: "BetweenMyCardsCell", for: indexPath) as? BetweenMyCardsCell {
                BetweenMyCardsCell.configurated(with: transaction[indexPath.section].allTransactions[indexPath.row], with: typeOperation)
                cell = BetweenMyCardsCell
            }
        }
        else if (typeOperation == AllTransactionsOperation.CurrencyTransfer){
            if let CurrencyTransferCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTransferCell", for: indexPath) as? CurrencyTransferCell {
                CurrencyTransferCell.configurated(with: transaction[indexPath.section].allTransactions[indexPath.row], with: typeOperation)
                cell = CurrencyTransferCell
            }
        }
        else if (typeOperation == AllTransactionsOperation.ActivationCard || typeOperation == AllTransactionsOperation.DeActivationCard){
            
            if let CardTransactionCell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTransactionCell", for: indexPath) as? CardTransactionCell {
                CardTransactionCell.configurated(with: transaction[indexPath.section].allTransactions[indexPath.row], with: typeOperation)
                cell = CardTransactionCell
            }
        }
        else if (typeOperation == AllTransactionsOperation.PaymentCredit || typeOperation == AllTransactionsOperation.RepaymentCredit){
            if let PayCreditCell = tableView.dequeueReusableCell(withIdentifier: "CreditServiceCell", for: indexPath) as? PayCreditCell {
                PayCreditCell.configurated(with: transaction[indexPath.section].allTransactions[indexPath.row], with: typeOperation)
                cell = PayCreditCell
            }
        }
        cell.backgroundColor = .clear
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension HistoryController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(collectionView){
        case HistroryOperation :
            return ModelsHistory.HistoryOperation.count
        case FilterCollection :
            return ModelsHistory.TransactionFilterOperation.count
        default:
            return 0
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch(collectionView){
        case HistroryOperation :
            if let HistroryOperationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalyticsCell", for: indexPath) as? HistoryTransactionOperationCell {
                HistroryOperationCell.configurated(with: ModelsHistory.HistoryOperation[indexPath.row])
                cell = HistroryOperationCell
               // cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCollection)))
            }
            break
        case FilterCollection :
            if let FilterOperationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTransactionCell", for: indexPath) as? TransactionFilterOperationCell {
                FilterOperationCell.configurated(with: ModelsHistory.TransactionFilterOperation[indexPath.row])
                cell = FilterOperationCell
            }
            break
        default: break
        }
        return cell
    }
}
