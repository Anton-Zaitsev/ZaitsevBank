//
//  ImageAnalyzer.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 20.03.2022.
//

import Foundation
import Vision

protocol ImageAnalyzerProtocol: AnyObject {
    func didFinishAnalyzation(with result: Result<CreditCard, CreditCardScannerError>)
}

final class ImageAnalyzer {
    enum Candidate: Hashable {
        case number(String), name(String)
        case expireDate(DateComponents)
    }

    typealias PredictedCount = Int

    private var selectedCard = CreditCard()
    private var predictedCardInfo: [Candidate: PredictedCount] = [:]

    private weak var delegate: ImageAnalyzerProtocol?
    init(delegate: ImageAnalyzerProtocol) {
        self.delegate = delegate
    }

    // MARK: - Vision-related

    public lazy var request = VNRecognizeTextRequest(completionHandler: requestHandler)
    func analyze(image: CGImage) {
        let requestHandler = VNImageRequestHandler(
            cgImage: image,
            orientation: .up,
            options: [:]
        )

        do {
            try requestHandler.perform([request])
        } catch {
            let e = CreditCardScannerError(kind: .photoProcessing, underlyingError: error)
            delegate?.didFinishAnalyzation(with: .failure(e))
            delegate = nil
        }
    }

    lazy var requestHandler: ((VNRequest, Error?) -> Void)? = { [weak self] request, _ in
        guard let strongSelf = self else { return }

        let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
        let month: Regex = #"(\d{2})\/\d{2}"#
        let year: Regex = #"\d{2}\/(\d{2})"#
        let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward","сбербанк","900","мир","мультикарта","втб","польза","home","credit"]
        // These may be contained in the date strings, so ignore them only for names
        let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year","rub","debit","card"]
        let name: Regex = #"([A-z]{2,}\h([A-z.]+\h)?[A-z]{2,})"#

        guard let results = request.results as? [VNRecognizedTextObservation] else { return }

        var creditCard = CreditCard(number: nil, name: nil, expireDate: nil)

        let maxCandidates = 1
        
        for result in results {
            guard
                let candidate = result.topCandidates(maxCandidates).first,
                candidate.confidence > 0.1
            else { continue }

            let string = candidate.string
            let containsWordToSkip = wordsToSkip.contains { string.lowercased().contains($0) }
            if containsWordToSkip { continue }

            if let cardNumber = creditCardNumber.firstMatch(in: string)?
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "") {
                creditCard.number = cardNumber

                // the first capture is the entire regex match, so using the last
            } else if let month = month.captures(in: string).last.flatMap(Int.init),
                // Appending 20 to year is necessary to get correct century
                let year = year.captures(in: string).last.flatMap({ Int("20" + $0) }) {
                creditCard.expireDate = DateComponents(year: year, month: month)

            } else if let name = name.firstMatch(in: string) {
                let containsInvalidName = invalidNames.contains { name.lowercased().contains($0) }
                if containsInvalidName { continue }
                creditCard.name = name

            } else {
                continue
            }
        }
        // Name
        if let name = creditCard.name {
            let count = strongSelf.predictedCardInfo[.name(name), default: 0]
            strongSelf.predictedCardInfo[.name(name)] = count + 1
            if count > 2 {
                strongSelf.selectedCard.name = name
            }
        }
        // ExpireDate
        if var date = creditCard.expireDate {
            let count = strongSelf.predictedCardInfo[.expireDate(date), default: 0]
            strongSelf.predictedCardInfo[.expireDate(date)] = count + 1
            if count > 2 {
                // Последний день текущего месяца
                let cal = Calendar.current
                var comps = DateComponents(calendar: cal, year: date.year, month: date.month)
                comps.setValue(date.month! + 1, for: .month)
                comps.setValue(0, for: .day)
                let Date = cal.date(from: comps)!
                date.day = cal.component(.day, from: Date)
                strongSelf.selectedCard.expireDate = date
            }
        }
        // Number
        if let number = creditCard.number {
            let count = strongSelf.predictedCardInfo[.number(number), default: 0]
            strongSelf.predictedCardInfo[.number(number)] = count + 1
            if count > 2 {
                strongSelf.selectedCard.number = number.formatCardNumber()
            }
        }

        if strongSelf.selectedCard.number != nil && strongSelf.selectedCard.name != nil && strongSelf.selectedCard.expireDate != nil {
            strongSelf.delegate?.didFinishAnalyzation(with: .success(strongSelf.selectedCard))
            strongSelf.delegate = nil
        }
    }
}
