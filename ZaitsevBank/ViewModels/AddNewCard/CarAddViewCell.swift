//
//  CarAddViewCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 08.11.2021.
//

import UIKit

class CarAddViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ViewCard: UIView!
    
    @IBOutlet weak var NameBank: UILabel!
    
    @IBOutlet weak var TypeSIM: UIImageView!
    
    @IBOutlet weak var ViewDataCard: UIStackView!
    
    @IBOutlet weak var OwnerCard: UILabel!
    
    @IBOutlet weak var TypeCard: UILabel!
    
    @IBOutlet weak var MainLabelNameCard: UILabel!
    
    @IBOutlet weak var SubLabelTypeCard: UILabel!
    
    @IBOutlet weak var PreferenceTable: UITableView!
    
    private var dataPreference : [CardAddPerformance] = []
    
    func configurated(with data: CardAddStructData) {
        ViewCard.layer.cornerRadius = 15
        dataPreference = data.dataCard
        
        NameBank.text = data.typeBank.uppercased()
        
        if (data.newDesign){
            ViewDataCard.isHidden = true
            OwnerCard.isHidden = true
        }
        else {
            if (data.typeSIM == "defaultCardSIM"){
                TypeSIM.layer.cornerRadius = 10
                TypeSIM.backgroundColor = .white
            }
            TypeSIM.image = UIImage(named: data.typeSIM)
            OwnerCard.text = data.nameFamily.uppercased()
        }
        
        TypeCard.text = data.typeCard.uppercased()
        MainLabelNameCard.text = data.typeLabelCard
        SubLabelTypeCard.text = data.typeBuyCard
        
        PreferenceTable.delegate = self
        PreferenceTable.dataSource = self
        
    }
    
}

extension CarAddViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataPreference.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if let PreferenceCell = tableView.dequeueReusableCell(withIdentifier: "cellPreferenceCard", for: indexPath) as? PreferenceCardAddViewCell {
            PreferenceCell.configurated(with: self.dataPreference[indexPath.row])
            cell = PreferenceCell
        }
        return cell
    }
    
}


