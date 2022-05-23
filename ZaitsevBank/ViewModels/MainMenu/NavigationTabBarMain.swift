//
//  NavigationTabBarMain.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class NavigationTabBarMain: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Main = storyboard?.instantiateViewController(withIdentifier: "StartMainMenu") as! StartMainController
                     
        let Payments = storyboard?.instantiateViewController(withIdentifier: "Payments") as! PaymentsController
        
        let History = storyboard?.instantiateViewController(withIdentifier: "History") as! HistoryController
        
        
        Main.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        Payments.tabBarItem = UITabBarItem(title: "Платежи", image: UIImage(systemName: "chart.bar.doc.horizontal"), selectedImage: UIImage(systemName: "chart.bar.doc.horizontal.fill"))
        History.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
        
        setViewControllers([Main,Payments,History], animated: false)
        tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        let customViewControllersArray : NSArray = [self]
        navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
      
    }

}


