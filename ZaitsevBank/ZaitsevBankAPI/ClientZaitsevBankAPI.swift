//
//  ClientZaitsevBankAPI.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.04.2022.
//

import Foundation

public class ClienZaitsevBankAPI {
    
    private static let server: String = "https://zaitsevbank.site/"
    
    public static func getRequestSignAccount(login: String, password: String) -> URLRequest {
        let SignAccount = URL(string: "\(server)api/Users/Sign")
        
        var request = URLRequest(url: SignAccount!)
        request.setValue(login, forHTTPHeaderField: "login")
        request.setValue(password, forHTTPHeaderField: "password")
        request.httpMethod = "GET"
        
        return request
    }
    
    public static func getRequestCreateAccount(model: LoginModel) -> URLRequest {
        let phone = "8" + String(model.Phone.compactMap({ $0.isWhitespace ? nil : $0 })).replacingOccurrences(of:  "(", with: "").replacingOccurrences(of:  ")", with: "").replacingOccurrences(of:  "-", with: "").replacingOccurrences(of:  "+", with: "")
        
        let requestCreate = model.FamilyName == nil ?  "\(server)api/Users/CreateAccount?FirstName=\(model.Name)&LastName=\(model.Family)&Birthday=\(model.Year)&Gender=\(model.Pol)" : "\(server)api/Users/CreateAccount?FirstName=\(model.Name)&LastName=\(model.Family)&MiddleName=\(model.FamilyName!)&Birthday=\(model.Year)&Gender=\(model.Pol)"
        
        let CreateAccount = URL(string: requestCreate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        var request = URLRequest(url: CreateAccount!)
        request.setValue(model.Login, forHTTPHeaderField: "login")
        request.setValue(model.Password, forHTTPHeaderField: "password")
        request.setValue(phone, forHTTPHeaderField: "phone")
        request.httpMethod = "POST"
        return request
    }
    
    public static func getRequestGetUserData(userID: String) -> URLRequest {
        let GetUserData = URL(string: "\(server)api/Users/GetUserData?userID=\(userID)")
        var request = URLRequest(url: GetUserData!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestCreateCard(userID: String, CardOperator: String, NameCard: String,TypeMoney: String) -> URLRequest{
        let CreateCard = URL(string: "\(server)api/Card/CreateCard?userID=\(userID)&CardOperator=\(CardOperator)&NameCard=\(NameCard)&TypeMoney=\(TypeMoney)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: CreateCard!)
        request.httpMethod = "POST"
        return request
    }
    
    public static func getRequestGetAllCards(userID: String, _ filterCardTransaction: String? = nil) -> URLRequest {
        if let filterCardTransaction {
            let GetUserData = URL(string: "\(server)api/Card/GetAllCards?userID=\(userID)&filterCard=\(filterCardTransaction)")
            var request = URLRequest(url: GetUserData!)
            request.httpMethod = "GET"
            return request
        }
        else {
            let GetUserData = URL(string: "\(server)api/Card/GetAllCards?userID=\(userID)")
            var request = URLRequest(url: GetUserData!)
            request.httpMethod = "GET"
            return request
        }
    }
    
    public static func getRequestGetCardFromPhone(Phone: String,userID: String) -> URLRequest {
        let GetCardFromPhone = URL(string: "\(server)api/Card/GetCardFromPhone?Phone=\(Phone)&userID=\(userID)")
        var request = URLRequest(url: GetCardFromPhone!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestGetCardFromNumber(NumberCard: String,userID: String) -> URLRequest {
        let GetCardFromNumber = URL(string: "\(server)api/Card/GetCardFromNumber?NumberCard=\(String(NumberCard.compactMap({ $0.isWhitespace ? nil : $0 })))&userID=\(userID)")
        var request = URLRequest(url: GetCardFromNumber!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestGetCardsBuySale(userID: String, TypeValute: String, BuySale: Bool) -> URLRequest {
        let buysale = BuySale ? "true" : "false"
        let GetCardsBuySale = URL(string: "\(server)api/Card/GetCardsBuySale?userID=\(userID)&TypeValute=\(TypeValute)&BuySale=\(buysale)")
        var request = URLRequest(url: GetCardsBuySale!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestGetPopListValute(ElectronValute: Bool) -> URLRequest {
        let electronValute = ElectronValute ? "true" : "false"
        let GetPopListValute = URL(string:"\(server)api/Valute/GetPopListValute?ElectronValute=\(electronValute)")
        var request = URLRequest(url: GetPopListValute!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestValuteAtoValuteB(ValuteA: String, ValuteB: String,BuySale: Bool,Count: Double?) -> URLRequest {
        let buySale = BuySale ? "true" : "false"
        let count = Count == nil ? "" : "&count=\(Count!)"
        let ValuteAtoValuteB = URL(string:"\(server)api/Valute/ValuteATOValuteB?ValuteA=\(ValuteA)&ValuteB=\(ValuteB)&BuySale=\(buySale)\(count)")
        var request = URLRequest(url: ValuteAtoValuteB!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestGetExchangeList(ElectronValute: Bool) -> URLRequest {
        let electronValute = ElectronValute ? "true" : "false"
        let GetExchangeList = URL(string:"\(server)api/Valute/GetExchangeList?ElectronValute=\(electronValute)")
        var request = URLRequest(url: GetExchangeList!)
        request.httpMethod = "GET"
        return request
    }
    // Transactions
    
    public static func getRequestTransferClient(TransactionSender: String, TransactionRecipient: String, summ: String) -> URLRequest{
        let TransferClient = URL(string:"\(server)api/Transactions/TransferClient?TransactionSender=\(TransactionSender)&TransactionRecipient=\(TransactionRecipient)&Summ=\(summ)")
        var request = URLRequest(url: TransferClient!)
        request.httpMethod = "POST"
        return request
    }
    
    public static func getRequestGetAllTransactiont(userID: String,DateFrom: String, DateTo: String) -> URLRequest{
        let GetAllTransactiont = URL(string:"\(server)api/Transactions/GetAllTransaction?userID=\(userID)&dataFrom=\(DateFrom)&dataTo=\(DateTo)")
        var request = URLRequest(url: GetAllTransactiont!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestValuteBuySale(transactionCardA: String, transactionCardB: String,Summ: String, BuySale: Bool) -> URLRequest{
        let bool = BuySale ? "true" : "false"
        let ValuteBuySale = URL(string:"\(server)api/Transactions/ValuteBuySale?CardA=\(transactionCardA)&CardB=\(transactionCardB)&Summ=\(Summ)&BuySale=\(bool)")
        var request = URLRequest(url: ValuteBuySale!)
        request.httpMethod = "POST"
        return request
    }
    
    public static func getRequestCheckCredit(count: String, year: String) -> URLRequest {
        let checkCredit = URL(string:"\(server)api/Transactions/CheckCredit?count=\(count)&year=\(year)")
        var request = URLRequest(url: checkCredit!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestApplyCredit(count: String, year: String, transactionCard: String) -> URLRequest{
        let ApplyCredit = URL(string:"\(server)api/Transactions/ApplyCredit?count=\(count)&year=\(year)&transactionCard=\(transactionCard)")
        var request = URLRequest(url: ApplyCredit!)
        request.httpMethod = "POST"
        return request
    }
    
    public static func getRequestGetListCredits(userID: String, allList: Bool = false) -> URLRequest{

       let GetListCredits = allList ?  URL(string:"\(server)api/Transactions/GetListCredits?userID=\(userID)&allList=true") :
        
            URL(string:"\(server)api/Transactions/GetListCredits?userID=\(userID)")

        var request = URLRequest(url: GetListCredits!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestAddMoneyCredit(transactionCredit: String, transactionCard: String, creditID: String) -> URLRequest {
        let AddMoneyCredit = URL(string:"\(server)api/Transactions/AddMoneyCredit?transactionCredit=\(transactionCredit)&transactionCard=\(transactionCard)&creditID=\(creditID)")

         var request = URLRequest(url: AddMoneyCredit!)
         request.httpMethod = "POST"
         return request
        
    }
    
    public static func getRequestGetFinanceMonth(userID: String) -> URLRequest {
        let GetFinanceMonth = URL(string:"\(server)api/Finance/GetFinanceMonth?userID=\(userID)")
         var request = URLRequest(url: GetFinanceMonth!)
         request.httpMethod = "GET"
         return request
        
    }
}


