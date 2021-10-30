//
//  NavigationTabBarMain.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class NavigationTabBarMain: UITabBarController {

    public var dataUser : clientZaitsevBank!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Main = storyboard?.instantiateViewController(withIdentifier: "StartMainMenu") as! StartMainController
        let test = clientZaitsevBank()
        Main.dataUser = test
        Main.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let Payments = storyboard?.instantiateViewController(withIdentifier: "Payments") as! PaymentsController
        Payments.tabBarItem = UITabBarItem(title: "Платежи", image: UIImage(systemName: "chart.bar.doc.horizontal"), selectedImage: UIImage(systemName: "chart.bar.doc.horizontal.fill"))
        
        let History = storyboard?.instantiateViewController(withIdentifier: "History") as! HistoryController
        History.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
        
        self.viewControllers = [Main,Payments,History]
    }
    

}
