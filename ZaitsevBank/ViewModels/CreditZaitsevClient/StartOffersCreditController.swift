//
//  StartOffersCreditController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 25.05.2022.
//

import UIKit

class StartOffersCreditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.isNavigationBarHidden = false;
    }

}
