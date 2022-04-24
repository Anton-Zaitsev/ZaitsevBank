//
//  PaymentsController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class PaymentsController: UIViewController {

    @IBOutlet weak var VIewAllCollection: UIView!
    
    @IBOutlet weak var HistroryCollection: UICollectionView!
    
    @IBOutlet weak var TransferTable: UITableView!
    
    @IBOutlet weak var PaymentTable: UITableView!
    
    private let historyPayments = HistoryPayment()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        VIewAllCollection.roundTopCorners(radius: 20)
        
        HistroryCollection.delegate = self
        HistroryCollection.dataSource = self
                
        TransferTable.delegate = self
        TransferTable.dataSource = self
                
        PaymentTable.delegate = self
        PaymentTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true;
    }
        
    /*
    @IBAction func ScanCard(_ sender: Any) {

        let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
        let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
        storyboardInstance.delegate = self
        storyboardInstance.modalPresentationStyle = .fullScreen
        present(storyboardInstance, animated: true, completion: nil)
    }
     */
}
extension PaymentsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyPayments.HistoryOperationHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let HistoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyOperation", for: indexPath) as? HistoryOperationCell {
            HistoryCell.configurated(with: historyPayments.HistoryOperationHeader[indexPath.row])
            cell = HistoryCell
        }
        return cell
    }
}
extension PaymentsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView{
        case TransferTable :
            return historyPayments.OperationTransfer.count
        case PaymentTable :
            return historyPayments.OperationPayment.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch tableView {
        case TransferTable:
            if let TransferCell = tableView.dequeueReusableCell(withIdentifier: "transferCell", for: indexPath) as? TransferCell {
                TransferCell.configurated(with: historyPayments.OperationTransfer[indexPath.row])
                cell = TransferCell
            }
            return cell
        case PaymentTable:
            if let PaymentsCell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as? PaymentCell {
                PaymentsCell.configurated(with: historyPayments.OperationPayment[indexPath.row])
                cell = PaymentsCell
            }
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView{
        case TransferTable :
            break
        case PaymentTable :
            break
        default: return
        }
        
        
            /*
            let storyboardCardViewer : UIStoryboard = UIStoryboard(name: "CardViewer", bundle: nil)
            let CardViewer = storyboardCardViewer.instantiateViewController(withIdentifier: "CardView") as! FullCardController
            
            CardViewer.cardFull = modelStartMain.cardUser
            CardViewer.indexCard = indexPath
            navigationController?.isNavigationBarHidden = false;
            
            self.navigationController?.pushViewController(CardViewer, animated: true)
             */
        
    }
    
}


/*
extension PaymentsController: CreditCardScannerViewControllerDelegate {
    func creditCardScannerViewControllerDidCancel(_ viewController: CardScannerController) {
        viewController.dismiss(animated: true, completion: nil)
        print("cancel")
    }

    func creditCardScannerViewController(_ viewController: CardScannerController, didErrorWith error: CreditCardScannerError) {
        print(error.errorDescription ?? "")
        ResultLabel.text = error.errorDescription
        viewController.dismiss(animated: true, completion: nil)
    }

    func creditCardScannerViewController(_ viewController: CardScannerController, didFinishWith card: CreditCard) {
        viewController.dismiss(animated: true, completion: nil)

        var dateComponents = card.expireDate
        dateComponents?.calendar = Calendar.current
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        let date = dateComponents?.date.flatMap(dateFormater.string)

        let text = [card.number, date, card.name]
            .compactMap { $0 }
            .joined(separator: "\n")
        ResultLabel.text = text
        print("\(card)")
    }
}
*/
