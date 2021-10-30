//
//  StartMainController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 10.10.2021.
//

import UIKit



class StartMainController: UIViewController {
    
    public var data = StartMenu()
    fileprivate let dataValute = API.getDataValute()
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelValute: UILabel!
    @IBOutlet weak var CollectionOffers: UICollectionView!
    
    public var dataUser : clientZaitsevBank!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true;
        GetView()
    }
    private func GetView() {
        //LabelName.text = dataUser.name
        CollectionOffers.delegate = self
        CollectionOffers.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] (_) in
            LabelValute.fadeTransition(0.4)
            if (count == dataValute.count){
                LabelValute.text = "Добро пожаловать в Zaitsev Банк"
            }
            else {
                let text = "\(dataValute[count].nameValute): \(dataValute[count].countValute) \(dataValute[count].changes)"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributedString.setColor(color: dataValute[count].ValuePlus ? .green : .red, forText: "\(dataValute[count].changes)")
                LabelValute.attributedText = attributedString
            }
            count = count == dataValute.count ? 0 : count + 1

        }

    }
    

    
    
}

extension StartMainController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.dataOffers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let OffersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "offers", for: indexPath) as? OffersViewCell {
            OffersCell.configurated(with: self.data.dataOffers[indexPath.row].title , with: self.data.dataOffers[indexPath.row].backgroundImage)
            cell = OffersCell
        }
        return cell
    }
}



