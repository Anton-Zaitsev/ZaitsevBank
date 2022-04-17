//
//  PaymentsController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class PaymentsController: UIViewController {

    @IBOutlet weak var ResultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func ScanCard(_ sender: Any) {

        let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
        let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
        storyboardInstance.delegate = self
        storyboardInstance.modalPresentationStyle = .fullScreen
        present(storyboardInstance, animated: true, completion: nil)
    }
}

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
