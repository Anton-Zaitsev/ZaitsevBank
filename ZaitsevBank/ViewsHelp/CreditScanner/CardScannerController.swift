//
//  CardScannerController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.03.2022.
//

import AVFoundation
import Foundation
import UIKit

public protocol CreditCardScannerViewControllerDelegate: AnyObject {
    func creditCardScannerViewControllerDidCancel(_ viewController: CardScannerController)
    
    func creditCardScannerViewController(_ viewController: CardScannerController, didErrorWith error: CreditCardScannerError)
    
    func creditCardScannerViewController(_ viewController: CardScannerController, didFinishWith card: CreditCard)
}
public extension CreditCardScannerViewControllerDelegate where Self: UIViewController {
    func creditCardScannerViewControllerDidCancel(_ viewController: CardScannerController) {
        viewController.dismiss(animated: true)
    }
}

open class CardScannerController: UIViewController{

    @IBOutlet weak var cameraView: CameraView!
        
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var CardNumber: UILabel!
    @IBOutlet weak var CardName: UILabel!
    @IBOutlet weak var CardDate: UILabel!
    @IBOutlet weak var CardType: UIImageView!
    
    public func getViewCard(_ card: CreditCard) {
        if let number = card.number {
            if let name = card.name {
                if let data = card.expireDate {
                    CardNumber.text = number
                    CardName.text = name
                    let month = data.month!
                    let nowYear = 2000
                    let year = String(data.year! - nowYear)
                    let cardType = "\(number.first!)".searchOperatorCard()
                    CardType.image = UIImage(named: cardType)
                    CardDate.text = "До \(month < 10 ? "0\(month)" : "\(month)" )/\(year)"
                    
                    CardView.isHidden = false
                }
            }
        }
    }
    private lazy var analyzer = ImageAnalyzer(delegate: self)

    public weak var delegate: CreditCardScannerViewControllerDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.authorize { [weak self] authoriazed in
            // This is on the main thread.
            guard let strongSelf = self else {
                return
            }
            guard authoriazed else {
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: CreditCardScannerError(kind: .authorizationDenied, underlyingError: nil))
                return
            }
            strongSelf.cameraView.setupCamera()
        }
        
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.delegate = self
        cameraView.setupRegionOfInterest()
    }
    
    @IBAction func CancelClick(_ sender: Any) {
        delegate?.creditCardScannerViewControllerDidCancel(self)
    }
}

extension CardScannerController: CameraViewDelegate {
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }

    internal func didError(with error: CreditCardScannerError) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            strongSelf.cameraView.stopSession()
        }
    }
}

extension CardScannerController: ImageAnalyzerProtocol {
    internal func didFinishAnalyzation(with result: Result<CreditCard, CreditCardScannerError>) {
        switch result {
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.strokeLayer.strokeColor = UIColor.green.cgColor // Рамку окрашиваем в зеленый цвет
                self!.getViewCard(creditCard)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    strongSelf.cameraView.stopSession()
                    strongSelf.delegate?.creditCardScannerViewController(strongSelf, didFinishWith: creditCard)
                }
            }

        case let .failure(error):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            }
        }
    }
}

extension AVCaptureDevice {
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }

        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
            })
        default:
            mainThreadHandler(false)
        }
    }
}
