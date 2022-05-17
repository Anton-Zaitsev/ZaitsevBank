//
//  HistoryController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class HistoryController: UIViewController {

    private let ModelsHistory: HistoryTransactionModels = HistoryTransactionModels()
    
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
    
    @IBOutlet weak var HistroryOperation: UICollectionView!
    
    @IBOutlet weak var FilterCollection: UICollectionView!
    
    @IBOutlet weak var ViewTransaction: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        ViewTransaction.roundTopCorners(radius: 20)
        
        HistroryOperation.delegate = self
        HistroryOperation.dataSource = self
        
        FilterCollection.delegate = self
        FilterCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true;
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
