//
//  PaymentsController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class PaymentsController: UIViewController {

    @IBOutlet weak var HistroryCollection: UICollectionView!
    private var dataHistory : [HistoryOperation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataHistory = getDefaultHistory()
        HistroryCollection.delegate = self
        HistroryCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true;
    }
        
    private func getDefaultHistory() -> [HistoryOperation] {
        var operation: [HistoryOperation]  = []
        let operationMoneyTransfer = HistoryOperation(typeOperation: "Перевод", iconOperation: UIImage(systemName: "arrow.uturn.forward")!, nameOperation: "Перевести денег")
        operation.append(operationMoneyTransfer)
        
        return operation
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
        return dataHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let HistoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyOperation", for: indexPath) as? HistoryOperationCell {
            HistoryCell.configurated(with: dataHistory[indexPath.row])
            cell = HistoryCell
        }
        return cell
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
