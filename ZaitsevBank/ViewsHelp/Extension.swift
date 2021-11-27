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
        let ok = UIAlertAction(title: "ОК", style: .default, handler: { action in
        })
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}


extension UIViewController {
    
    func EnableMainLoader(NameUser: String = ""){
        var nameUser = NameUser
        let screen = UIScreen.main.bounds
        let viewLoader = UIView(frame: screen)
        let LoaderView : UIImageView = UIImageView(frame: screen)
        let labelName = UILabel(frame: CGRect(x: 0, y: CGFloat(100), width: screen.width, height: 100))
        
        if (UserDefaults.standard.checkNameScreensaver()) {
            nameUser = UserDefaults.standard.isNameScreensaver()
        }
        else {
            UserDefaults.standard.SetisNameScreensaver(NameUser)
        }
        
        labelName.text = "Добро пожаловать,\n \(nameUser)"
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
    }
    
    func DisableLoader(loader: UIView) {
        DispatchQueue.main.async {
            loader.removeFromSuperview()
        }
    }
    
    func EnableLoader() -> UIView{
        let screen = UIScreen.main.bounds
        let view = UIView(frame: screen)
        let viewLoader = UIView(frame: screen)
        viewLoader.backgroundColor = .black
        viewLoader.layer.opacity = 0.5
        guard let LoaderView = UIImageView.loadGifLoading() else { return viewLoader }
        view.addSubview(viewLoader)
        view.addSubview(LoaderView)
        self.view.addSubview(view)
        LoaderView.startAnimating()
        return view
    }
    
}

extension UIImageView {
    static func loadGifLoading() -> UIImageView? {
        guard let path = Bundle.main.path(forResource: "Loading", ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let screen = UIScreen.main.bounds
        let imageWidth:CGFloat = 150
        let gifImageView = UIImageView()
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.frame = CGRect.init(x: (screen.width/2)-imageWidth/2, y: (screen.height/2)-imageWidth/2, width: imageWidth, height: imageWidth)
        gifImageView.clipsToBounds = true
        gifImageView.animationImages = images
        return gifImageView
    }
}

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

extension UIView {

        func fadeTransition(_ duration:CFTimeInterval) {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.duration = duration
            layer.add(animation, forKey: CATransitionType.fade.rawValue)
        }
}

extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
       self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}

extension UIView{

    func showFlip(){
        if self.isHidden{
            
            UIView.transition(with: self, duration: 0.3, options: [.transitionFlipFromRight,.allowUserInteraction], animations: nil, completion: nil)
            self.isHidden = false
        }
        
    }
    func hideFlip(){
        if !self.isHidden{
            UIView.transition(with: self, duration: 0.3, options: [.transitionFlipFromLeft,.allowUserInteraction], animations: nil,  completion: nil)
            self.isHidden = true
        }
    }
}
