//
//  Extension.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 05.10.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withTitle title: String, withMessage message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
}


extension UIViewController {
    func EnableLoader() -> UIView {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let screen = UIScreen.main.bounds
        let viewLoader = UIView(frame: screen)
        let LoaderView : UIImageView = UIImageView(frame: screen)
        let labelName = UILabel(frame: CGRect(x: 0, y: CGFloat(100), width: screen.width, height: 100))
        labelName.text = "Добро пожаловать,\n Антон"
        labelName.textAlignment = .center
        labelName.font = UIFont(name:"HelveticaNeue-Bold", size: 31.0)
        labelName.textColor = .white
        labelName.minimumScaleFactor = 16
        labelName.numberOfLines = 0
        LoaderView.image = UIImage(named: "BackroundOpenClient")
        LoaderView.sizeToFit()
        viewLoader.addSubview(LoaderView)
        viewLoader.addSubview(labelName)
        self.view.addSubview(viewLoader)
        return viewLoader
    }
    func DisableLoader(loader: UIView) {
        DispatchQueue.main.async {
            loader.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}


