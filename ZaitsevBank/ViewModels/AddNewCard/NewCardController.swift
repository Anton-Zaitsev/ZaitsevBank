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
    private var modelDataCard : CardAddModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelDataCard = CardAddModel(nameFamily: nameFamilyOwner)
        AddCardCollectionView.delegate = self
        AddCardCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension NewCardController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
