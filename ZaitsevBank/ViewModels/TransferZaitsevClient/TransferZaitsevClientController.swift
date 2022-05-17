//
//  TransferZaitsevClientController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 14.05.2022.
//

import UIKit
import ContactsUI

class TransferZaitsevClientController: UIViewController {
    
    
    @IBOutlet weak var SelectorContact: UIStackView!
    @IBOutlet weak var ContactView: UIView!
    @IBOutlet weak var ContactImage: UIImageView!
    @IBOutlet weak var ContactLabel: UILabel!
    
    @IBOutlet weak var SelectorCard: UIStackView!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var CardLabel: UILabel!
    @IBOutlet weak var CardImage: UIImageView!
    @IBOutlet weak var CardStack: UIStackView!
    
    private var AllContacts :  [TransferContactsModel] = [TransferContactsModel] ()
    private var contacts :  [TransferContactsModel] = [TransferContactsModel] ()
    
    private var transferType: TransferZaitsevType = TransferZaitsevType.Contacts // Дефолтное значение
    private let cardManager = CardsManager()
    
    @IBOutlet weak var SearchBar: UITextField!
    
    @IBOutlet weak var ContactTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        SearchBar.delegate = self
        ContactTable.delegate = self
        ContactTable.dataSource = self
        
        SearchBar.attributedPlaceholder =
        NSAttributedString(string: "Номер телефона или имя клиента", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 14,weight: .semibold)])
        
        ContactImage.tintColor = .white
        ContactView.layer.cornerRadius = ContactView.bounds.height / 2
        ContactView.layer.masksToBounds = true
        ContactView.backgroundColor = UIColor("#108F2A")
        ContactLabel.textColor = UIColor("#108F2A")
        
        CardView.layer.cornerRadius = CardView.bounds.height / 2
        CardView.layer.masksToBounds = true
        
        let tapContact = UITapGestureRecognizer(target: self, action: #selector(ContactTap))
        SelectorContact.isUserInteractionEnabled = true
        SelectorContact.addGestureRecognizer(tapContact)
        
        let tapCard = UITapGestureRecognizer(target: self, action: #selector(CardTap))
        SelectorCard.isUserInteractionEnabled = true
        SelectorCard.addGestureRecognizer(tapCard)
        
    }
    
    @objc private func ContactTap(sender: UITapGestureRecognizer) {
        ContactView.backgroundColor = UIColor("#108F2A")
        ContactLabel.textColor = UIColor("#108F2A")
        ContactImage.tintColor = .white
        contacts = AllContacts
        ContactTable.reloadData()
        CardView.backgroundColor = .clear
        CardLabel.textColor = .darkGray
        CardImage.tintColor = .darkGray
        CardStack.isHidden = true
        ContactTable.isHidden = false
        SearchBar.text = ""
        SearchBar.attributedPlaceholder =
        NSAttributedString(string: "Номер телефона или имя клиента", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 14,weight: .semibold)])
        
        transferType = TransferZaitsevType.Contacts
        
        SearchBar.keyboardType = .default
        SearchBar.resignFirstResponder()
        SearchBar.becomeFirstResponder()
    }
    
    @objc private func CardTap(sender: UITapGestureRecognizer) {
        CardView.backgroundColor = UIColor("#108F2A")
        CardLabel.textColor = UIColor("#108F2A")
        CardImage.tintColor = .white
        ContactTable.isHidden = true
        CardStack.isHidden = false
        ContactView.backgroundColor = .clear
        ContactLabel.textColor = .darkGray
        ContactImage.tintColor = .darkGray
        
        SearchBar.text = ""
        SearchBar.attributedPlaceholder =
        NSAttributedString(string: "Номер карты получателя", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 14,weight: .semibold)])
        
        transferType = TransferZaitsevType.Cards
        
        SearchBar.keyboardType = .numberPad
        SearchBar.resignFirstResponder()
        SearchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.isNavigationBarHidden = false;
        SearchBar.becomeFirstResponder()
    }

    @IBAction func TransferCardNumber(_ sender: Any) {
        let cardText = SearchBar.text ?? ""
        if (cardText.count == 19){
            SearchBar.resignFirstResponder()
            let loader = EnableLoader()
            DispatchQueue.global(qos: .utility).async{ [self] in
                Task(priority: .high) {
                    if let cardSearch = await cardManager.GetCardFromNumberCard(numberCard: cardText){
                        DispatchQueue.main.async { [self] in
                            DisableLoader(loader: loader)
                            
                            let TransferByCamera = storyboard?.instantiateViewController(withIdentifier: "TransferCamera") as! TransferCameraController
                            TransferByCamera.SearchCard = cardSearch
                            navigationController?.pushViewController(TransferByCamera, animated: true)
                            
                            // Переход в TransferByCamera с отключение переход в камеру
                        }
                    }
                    else {
                        DispatchQueue.main.async { [self] in
                            DisableLoader(loader: loader)
                            SearchBar.becomeFirstResponder()
                            showAlert(withTitle: "Произошла ошибка", withMessage: cardManager.Error)
                        }
                    }
                    
                }
            }
        }
        else {
            SearchBar.textColor = UIColor("#B20000")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.SearchBar.textColor = .white
            }
        }
    }
    private func getContacts()   {
        
        var Contacts :  [ContactsModel] =  [ContactsModel]()
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access:", err)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        let name = contact.givenName
                        let family = contact.familyName
                        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                        
                        if (name.isEmpty == false && phone != "") {
                            Contacts.append(ContactsModel(ImageContact: contact.imageDataAvailable ? UIImage(data: contact.imageData!) : nil, NameContact: name, FamilyContact: family, PhoneNumber: phone.formatPhone()))
                        }
                    })
                    
                    let dictContacts = Contacts.reduce([String: [ContactsModel]]()) { (key, value) -> [String: [ContactsModel]] in
                        var key = key
                        if let first = value.NameContact.first {
                            let prefix = String(describing: first).lowercased()
                            var array = key[prefix]
                            
                            if array == nil {
                                array = []
                            }
                            array!.append(value)
                            key[prefix] = array!.sorted(by: { $0.NameContact < $1.NameContact })
                        }
                        return key
                    }
                    
                    for contactsDict in dictContacts{
                        self.AllContacts.append(TransferContactsModel(SectionModel: contactsDict.key.uppercased(), Contacts: contactsDict.value))
                    }
                    self.AllContacts = self.AllContacts.sorted(by: { $0.SectionModel < $1.SectionModel})
                    self.contacts = self.AllContacts
                } catch let err {
                    print("Failed to enumerate contacts:", err)
                }
                
            } else {
                print("Access denied..")
            }
        }
    }
}
extension TransferZaitsevClientController: UITextFieldDelegate{
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        switch (transferType){
        case .Contacts :
            if (searchText.isEmpty){
                textField.text = searchText
                contacts = AllContacts
                ContactTable.reloadData()
            }
            else {
                if (searchText.first!.isNumber || searchText.contains("+")){
                    let formattedSearch = searchText.formatPhoneTextField()
                    textField.text = formattedSearch
                    
                    if (formattedSearch.isEmpty){ // Если отформатированный номер пришел нулевой, тогда обновляем на все
                        contacts = AllContacts
                        ContactTable.reloadData()
                    }
                    else {
                        contacts = AllContacts.filter(
                            {
                                $0.Contacts.filter(
                                    {
                                        $0.PhoneNumber.lowercased() == formattedSearch ||
                                        $0.PhoneNumber.lowercased().contains(formattedSearch)
                                    }).isEmpty == false
                            }
                        )
                        // Фильтруем
                        // Удаляем лишнии
                        contacts.indices.forEach( {
                            
                            contacts[$0].Contacts = contacts[$0].Contacts.filter(
                                {
                                    $0.PhoneNumber.lowercased() == formattedSearch ||
                                    $0.PhoneNumber.lowercased().contains(formattedSearch)
                                })
                        })
                        ContactTable.reloadData()
                    }
                }
                else {
                    let searchTextNotUpperCased = searchText.lowercased()
                    textField.text = searchText.firstUppercased
                    contacts = AllContacts.filter(
                        {
                            $0.Contacts.filter(
                                {
                                    $0.NameContact.lowercased().contains(searchTextNotUpperCased) ||
                                    $0.NameContact.lowercased() == searchTextNotUpperCased ||
                                    $0.FamilyContact.lowercased().contains(searchTextNotUpperCased) ||
                                    $0.FamilyContact.lowercased() == searchTextNotUpperCased
                                }).isEmpty == false
                        }
                    )
                    // Фильтруем
                    // Удаляем лишнии
                    contacts.indices.forEach( {
                        
                        contacts[$0].Contacts = contacts[$0].Contacts.filter(
                            {
                                $0.NameContact.lowercased().contains(searchTextNotUpperCased) ||
                                $0.NameContact.lowercased() == searchTextNotUpperCased ||
                                $0.FamilyContact.lowercased().contains(searchTextNotUpperCased) ||
                                $0.FamilyContact.lowercased() == searchTextNotUpperCased
                            })
                    })
                    ContactTable.reloadData()
                }
                
            }
            break
        case .Cards :
            textField.text = searchText.formatCardTextField()
            break
        }
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchBar.resignFirstResponder()
        return true;
    }
}
extension TransferZaitsevClientController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts[section].Contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contacts[section].SectionModel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let ContactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell {
            ContactCell.configurated(with: contacts[indexPath.section].Contacts[indexPath.row])
            cell = ContactCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        SearchBar.resignFirstResponder()
        let phone = contacts[indexPath.section].Contacts[indexPath.row].PhoneNumber
        let loader = EnableLoader()
        DispatchQueue.global(qos: .utility).async{ [self] in
            Task(priority: .high) {
                if let cardSearch = await cardManager.GetCardFromPhone(Phone: phone){
                    DispatchQueue.main.async { [self] in
                        DisableLoader(loader: loader)
                        
                        let TransferByCamera = storyboard?.instantiateViewController(withIdentifier: "TransferCamera") as! TransferCameraController
                        TransferByCamera.SearchCard = cardSearch
                        navigationController?.pushViewController(TransferByCamera, animated: true)
                        // Переход в TransferByCamera с отключение переход в камеру
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        DisableLoader(loader: loader)
                        SearchBar.becomeFirstResponder()
                        showAlert(withTitle: "Произошла ошибка", withMessage: cardManager.Error)
                    }
                }
                
            }
        }
        
    }
    
}
