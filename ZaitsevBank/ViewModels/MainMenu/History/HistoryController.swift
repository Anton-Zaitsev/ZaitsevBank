//
//  HistoryController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 22.10.2021.
//

import UIKit

class HistoryController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true;
    }
}
