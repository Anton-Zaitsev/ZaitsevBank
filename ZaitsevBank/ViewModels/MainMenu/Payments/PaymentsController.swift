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
    
    @IBOutlet weak var OperationAll: UITableView!
    
    private let historyPayments = HistoryPayment()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        VIewAllCollection.roundTopCorners(radius: 20)
        
        HistroryCollection.delegate = self
        HistroryCollection.dataSource = self
        
        OperationAll.delegate = self
        OperationAll.dataSource = self
        
        OperationAll.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true;
    }
    
    @objc private func tapCollection(_ sender: UITapGestureRecognizer) {

       let location = sender.location(in: self.HistroryCollection)
       let indexPath = self.HistroryCollection.indexPathForItem(at: location)

       if let index = indexPath {
           historyPayments.HistoryOperationHeader[index.row].typeOperation.OperationPerform(self)
       }
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
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCollection)))
        }
        return cell
    }
}

extension PaymentsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyPayments.OperationAll.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyPayments.OperationAll[section].listOperation.count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor("#1E1E1E")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        header.textLabel?.textColor = .white
        header.textLabel?.textAlignment = .left
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return historyPayments.OperationAll[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let AllOperationCell = tableView.dequeueReusableCell(withIdentifier: "allOperationCell", for: indexPath) as? AllOperationCell {
            AllOperationCell.configurated(with: historyPayments.OperationAll[indexPath.section].listOperation[indexPath.row])
            cell = AllOperationCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        historyPayments.OperationAll[indexPath.section].listOperation[indexPath.row].typeOperation.OperationPerform(self)
    }
    
}


