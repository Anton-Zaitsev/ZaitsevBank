//
//  FullCardController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 29.11.2021.
//

import UIKit

class FullCardController: UIViewController {
    private var scrollCard: Int = 0
    
    var cardFull : [Cards] = [Cards]()
    var indexCard: IndexPath!
    
    @IBOutlet weak var CollectionCard: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white ]
        CollectionCard.isPagingEnabled = true
        CollectionCard.delegate = self
        CollectionCard.dataSource = self
        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: false)

    }
    
    @objc func autoScroll() {
        let totalCount = cardFull.count-1
        if scrollCard == totalCount{
            scrollCard = 0
        }else {
            scrollCard += 1
        }
        DispatchQueue.main.async { [self] in
            let rect = CollectionCard.layoutAttributesForItem(at: indexCard)?.frame
            if scrollCard == 0{
                CollectionCard.scrollRectToVisible(rect!, animated: false)
            }else {
                CollectionCard.scrollRectToVisible(rect!, animated: true)
            }
        }
    }

}

extension FullCardController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.title = cardFull[indexPath.item].nameCard
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.visibleSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardFull.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? FullCardCell {
            CardCell.configurated(with: self.cardFull[indexPath.row])
            cell = CardCell
        }
        return cell
    }
    
}
