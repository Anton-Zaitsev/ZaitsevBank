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
    
    func EnableMainLoader(_ NameUser: String = ""){
        var nameUser = NameUser
        
        let screen = UIScreen.main.bounds
        let viewLoader = UIView(frame: screen)
        viewLoader.backgroundColor = .black
        let LoaderView : UIImageView = UIImageView(frame: screen)
        LoaderView.contentMode = .scaleAspectFit
        
        let labelName = UILabel(frame: CGRect(x: 0, y: CGFloat(100), width: screen.width, height: 100))
        
        if (UserDefaults.standard.checkNameScreensaver()) {
            nameUser = UserDefaults.standard.isNameScreensaver()
        }
        else {
            UserDefaults.standard.SetisNameScreensaver(NameUser)
        }
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 22 || hour <= 5   {
            labelName.text = "Доброй ночи,\n\(nameUser)"
        }
        else if hour >= 6 && hour <= 11 {
            labelName.text = "Доброго утра,\n\(nameUser)"
        }
        else if hour >= 12 && hour <= 17  {
            labelName.text = "Добрый день,\n\(nameUser)"
        }
        else if hour >= 18 && hour <= 21  {
            labelName.text = "Добрый вечер,\n\(nameUser)"
        }
        else {
            labelName.text = "Добро пожаловать,\n\(nameUser)"
        }
        labelName.textAlignment = .center
        labelName.font = UIFont(name:"HelveticaNeue-Bold", size: 31.0)
        labelName.textColor = .white
        labelName.minimumScaleFactor = 16
        labelName.numberOfLines = 0
        
        LoaderView.image = UIImage(named: "BackroundOpenClient")
        viewLoader.addSubview(LoaderView)
        viewLoader.addSubview(labelName)
        self.view.addSubview(viewLoader)
    }
    
    func DisableLoader(loader: UIView) {
        DispatchQueue.main.async {
            loader.removeFromSuperview()
        }
    }
    
    func EnableLoader(_ CustomView: CGRect = UIScreen.main.bounds) -> UIView{
        let screen = CustomView
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
    
    func roundTopCorners(radius: CGFloat = 10) {
        
           self.clipsToBounds = true
           self.layer.cornerRadius = radius
           if #available(iOS 11.0, *) {
               self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           } else {
               self.roundCorners(corners: [.topLeft, .topRight], radius: radius)
           }
       }

       func roundBottomCorners(radius: CGFloat = 10) {
        
           self.clipsToBounds = true
           self.layer.cornerRadius = radius
           if #available(iOS 11.0, *) {
               self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           } else {
               self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
           }
       }

       private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }

}
extension UIViewController {
    func setNavigationBar(_ title: String,_ color: UIColor = UIColor.white) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationController?.navigationBar.tintColor = .green
        
    }
}
extension UIColor {
    convenience init?(_ string: String) {
            let hex = string.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            
            if #available(iOS 13, *) {
                //If your string is not a hex colour String then we are returning white color. you can change this to any default colour you want.
                guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return nil }
                
                let a, r, g, b: Int32
                switch hex.count {
                case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
                case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
                case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
                default:    (a, r, g, b) = (255, 0, 0, 0)
                }
                
                self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
                
            } else {
                var int = UInt32()
                
                Scanner(string: hex).scanHexInt32(&int)
                let a, r, g, b: UInt32
                switch hex.count {
                case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
                case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
                case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
                default:    (a, r, g, b) = (255, 0, 0, 0)
                }
                
                self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
            }
        }
}
