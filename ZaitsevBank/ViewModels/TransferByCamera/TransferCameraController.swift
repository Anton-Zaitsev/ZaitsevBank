//
//  TransferCameraController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 24.04.2022.
//

import UIKit
class TransferCameraController: UIViewController,CardChoiseDelegate {
    
    func CardPick(Cards: [Cards]?, indexPickCard: Int?) {
        if let CardsUser = Cards {
            configuratedExpence(card: CardsUser[indexPickCard!])
        }
        else {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                Task(priority: .medium) {
                    
                    if let data = await AccountManager().GetUserData(){
                        DispatchQueue.main.async {
                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                            AddNewCardController.nameFamilyOwner = "\(data.firstName) \(data.lastName)"

                            self.DisableLoader(loader: loader)
                            self.navigationController?.pushViewController(AddNewCardController, animated: true)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о пользователе")
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBOutlet weak var ViewCard: UIStackView!
    
    private var ValutePay: String?
    
    @IBOutlet weak var ViewDataClient: UIView!
    
    @IBOutlet weak var TextNumberPhone: UILabel!
    
    @IBOutlet weak var NameClient: UILabel!
    
    @IBOutlet weak var ImageClient: UIImageView!
    
    @IBOutlet weak var TextFieldSumm: UITextField!
    
    //Expance
    @IBOutlet weak var ImageExpence: UIImageView!
    
    @IBOutlet weak var NameCard: UILabel!
    
    @IBOutlet weak var CountLabel: UILabel!
    
    @IBOutlet weak var CVVLabel: UILabel!
    
    private func configuratedExpence (card: Cards)  {
        ImageExpence.image = UIImage(named: card.typeImageCard)
        NameCard.text = card.nameCard
        CountLabel.text = "\(card.moneyCount) \(card.typeMoney)"
        CVVLabel.text = card.cvv
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        
        ValutePay = "RUB"
        
        ImageClient.layer.cornerRadius = ImageClient.bounds.height / 2
        ImageClient.image = textToImage(text: "A", textSize: ImageClient.bounds.height)
        
        TextFieldSumm.attributedPlaceholder =
        NSAttributedString(string: "Сумма зачисления", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        ImageExpence.image = UIImage(named: "")
        NameCard.text = "Выбере карту для перевода"
        CountLabel.text = ""
        CVVLabel.text = ""
        
        let tapOffs = UITapGestureRecognizer(target: self, action: #selector(СhoiceCard))
        ViewCard.isUserInteractionEnabled = true
        ViewCard.addGestureRecognizer(tapOffs)
        /*
        let storyboard = UIStoryboard(name: "CardViewer", bundle: nil)
        let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "CreditScanner") as! CardScannerController
        storyboardInstance.delegate = self
        storyboardInstance.modalPresentationStyle = .fullScreen
        present(storyboardInstance, animated: true, completion: nil)
         */
    }

    @objc private func СhoiceCard(sender: UITapGestureRecognizer) {
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardChoise") as! CardChoiceController
        CardPick.delegate = self
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
    }
    
    private func ConvertToDouble(Text: String) -> (Double,String)? {

        let formatText = String(Text.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  ",", with: ".")
        if let summToInt = Int(formatText){
            let summToIntToDouble = Double(summToInt)
            if (summToIntToDouble.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: ValutePay!)!.CountMaxDouble)){
                
                let fmt = NumberFormatter()
                fmt.numberStyle = .decimal
                fmt.locale = Locale(identifier: "fr_FR")
                return (summToIntToDouble, fmt.string(for: summToInt)! )
            }
            else {
                return nil
            }
        }
        else {
            if let summ = Double (formatText) {
                if (summ.maxNumber(CountMax: ValuteZaitsevBank.init(rawValue: ValutePay!)!.CountMaxDouble)){
                    return (summ,formatText.replacingOccurrences(of:  ".", with: ","))
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
    }
    
    @IBAction func SummEditing(_ sender: Any) {
        /*
        if let (valute, textValute) = ConvertToDouble(Text: TextFieldSumm.text ?? ""){
            TextFieldSumm.textColor = .black
            TextFieldSumm.text = textValute
           
        }
        else {
            TextFieldSumm.textColor = .red
        }
         */
    }
    func textToImage(text: String, textSize: CGFloat) -> UIImage {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize)
        ]
        let textSizeRender = text.size(withAttributes: attributes)

        let renderer = UIGraphicsImageRenderer(size: textSizeRender)
        let image = renderer.image(actions: { context in
            let rect = CGRect(origin: .zero, size: textSizeRender)
            text.draw(in: rect, withAttributes: attributes)
        })
        return image
    }
}


extension TransferCameraController: CreditCardScannerViewControllerDelegate {
    func creditCardScannerViewControllerDidCancel(_ viewController: CardScannerController) {
        viewController.dismiss(animated: true, completion: nil)
        print("cancel")
    }

    func creditCardScannerViewController(_ viewController: CardScannerController, didErrorWith error: CreditCardScannerError) {
        print(error.errorDescription ?? "")
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

        print("\(text)")
    }
}
