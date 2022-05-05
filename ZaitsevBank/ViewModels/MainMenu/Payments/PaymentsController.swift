//
//  PaymentsController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit
import PermissionsKit

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
        
}
extension PaymentsController: PermissionsDelegate,PermissionsDataSource {
    
    func configure(_ cell: PermissionTableViewCell, for permission: Permission) {

    }
        
        func deniedPermissionAlertTexts(for permission: Permission) -> DeniedPermissionAlertTexts? {
            // You can create custom texts
            
            
             let texts = DeniedPermissionAlertTexts()
             texts.titleText = "В разрешении отказано!"
             texts.descriptionText = "Пожалуйста, перейдите в Настройки и разрешите разрешение."
             texts.actionText = "Настройки"
             texts.cancelText = "Отмена"
             return texts


        }
    
    func didHidePermissions(_ permissions: [Permission]) {
        print("Example App: did hide with permissions", permissions.map { $0.debugName })
    }
    
    func didAllowPermission(_ permission: Permission) {
        print("Example App: did allow", permission.debugName)
    }
    
    func didDeniedPermission(_ permission: Permission) {
        print("Example App: did denied", permission.debugName)
    }
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
            historyPayments.OperationTransfer[indexPath.row].typeOperation.OperationPerform(self)
            break
        case PaymentTable :
            historyPayments.OperationPayment[indexPath.row].typeOperation.OperationPerform(self)
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

