//
//  TransactionTemplateController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.05.2022.
//

import UIKit

class TransactionTemplateController: UIViewController {

    @IBOutlet weak var SuccDown: UIView!
    @IBOutlet weak var SuccUp: UIView!
    
    @IBOutlet weak var MenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getView()
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor("#064433")!.cgColor,
            UIColor("#168E2F")!.cgColor
        ]
        gradient.locations = [0, 0.25]
        return gradient
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    private func getView() {
        SuccDown.layer.cornerRadius = SuccDown.bounds.height / 2
        SuccDown.layer.masksToBounds = true
        
        SuccDown.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        SuccUp.layer.cornerRadius = SuccUp.bounds.height / 2
        SuccUp.layer.masksToBounds = true
        SuccUp.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        MenuView.roundTopCorners(radius: 20)
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func ButtonUpClose(_ sender: Any) {
        
    }
    

}
