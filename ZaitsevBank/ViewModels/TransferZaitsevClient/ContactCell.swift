//
//  ContactCell.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 15.05.2022.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var LabelImageContact: UILabel!
    @IBOutlet weak var ImageContact: UIImageView!
    @IBOutlet weak var NameContact: UILabel!
    @IBOutlet weak var PhoneContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurated(with contact: ContactsModel) {
        
        if (contact.ImageContact != nil){
            LabelImageContact.isHidden = true
            ImageContact.isHidden = false
            ImageContact.layer.cornerRadius = ImageContact.bounds.height / 2
            ImageContact.image = contact.ImageContact
        }
        else {
            ImageContact.isHidden = true
            LabelImageContact.isHidden = false
            LabelImageContact.layer.cornerRadius = LabelImageContact.bounds.height / 2
            LabelImageContact.layer.masksToBounds = true
            LabelImageContact.text = contact.NameContact.first?.uppercased()
        }
        NameContact.text = "\(contact.NameContact.firstUppercased) \(contact.FamilyContact.firstUppercased)"
        PhoneContact.text = contact.PhoneNumber
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
