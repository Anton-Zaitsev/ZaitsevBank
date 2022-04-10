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
        let CreateAccount = URL(string: "\(server)api/Users/CreateAccount?FirstName=\(model.Name)&LastName=\(model.Family)&MiddleName=\(model.FamilyName)&Birthday=\(model.Year)&Gender=\(model.Pol)")
        
        var request = URLRequest(url: CreateAccount!)
        request.setValue(model.Login, forHTTPHeaderField: "login")
        request.setValue(model.Password, forHTTPHeaderField: "password")
        request.setValue(model.Phone, forHTTPHeaderField: "phone")
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
    
    public static func getRequestGetAllCards(userID: String) -> URLRequest {
        let GetUserData = URL(string: "\(server)api/Card/GetAllCards?userID=\(userID)")
        var request = URLRequest(url: GetUserData!)
        request.httpMethod = "GET"
        return request
    }
    
    public static func getRequestGetCardFromPhone(Phone: String, TypeValute: String) -> URLRequest {
        let GetUserData = URL(string: "\(server)api/Card/GetCardFromPhone?Phone=\(Phone)&TypeValute=\(TypeValute)")
        var request = URLRequest(url: GetUserData!)
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
}
