//
//  NewCardController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 08.11.2021.
//

import UIKit

class NewCardController: UIViewController {
    
    @IBOutlet weak var AddCardCollectionView: UICollectionView!
        
    public var nameFamilyOwner = "Андрей Гасанов"
    public var ValutePick : String?
    private var modelDataCard : CardAddModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelDataCard = CardAddModel(nameFamily: nameFamilyOwner)
        AddCardCollectionView.delegate = self
        AddCardCollectionView.dataSource = self
        
        AddCardCollectionView.isPagingEnabled = false
        AddCardCollectionView.isPagingEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func AcceptCard(_ sender: Any) {
        let ParametrsAddCardController = storyboard?.instantiateViewController(withIdentifier: "ParametrsCardMenu") as! ParametrsAddCardViewController
        ParametrsAddCardController.CARDDATA = modelDataCard.dataCard[getScrollIndexItem()]
        ParametrsAddCardController.ValutePick = ValutePick
        self.navigationController?.pushViewController(ParametrsAddCardController, animated: true)

    }
    
    fileprivate func getScrollIndexItem() -> Int {
        var visibleRect = CGRect()
        
        visibleRect.origin = AddCardCollectionView.contentOffset
        visibleRect.size = AddCardCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = AddCardCollectionView.indexPathForItem(at: visiblePoint) else { return 0 }
        
        return indexPath.row
    }
    
}


extension NewCardController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.visibleSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelDataCard.dataCard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let CarAddCels = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAddCard", for: indexPath) as? CarAddViewCell {
            CarAddCels.configurated(with: self.modelDataCard.dataCard[indexPath.row])
            cell = CarAddCels
        }
        return cell
    }
    
}
