//
//  Otherextensions.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit
import Toast_Swift
import SafariServices
import MessageUI
import Kingfisher
import FirebaseDatabase

extension UIViewController{
    
    func setNavigation(){
        NavigationModel.vcViewModel = self
        NavigationModel.setNavController(vc: self)
        setBackground()
        setTapGesture()
        
    }
    
    func setBackground(){
        self.view.backgroundColor  = .white
    }

    func setTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
        
    //MARK:- Alert/Toast
        func makeToast(strMessage:String){
            var style=ToastStyle()
            style.messageAlignment = .center
            self.view.makeToast(strMessage, duration: 3.0, position: .bottom,style:style)
        }
    
    func showSessionExpire(){
        let alert = UIAlertController(title: "Session Expired", message: "You need to login again..", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
          //  NavigationModel.redirectPerticularVC(to: LoginVC.self)
        }
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor{
    func getCustomColorWith(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    func hexToColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UILabel{
    func setCustomLBL(str:String,color:UIColor,align:NSTextAlignment,size:CGFloat){
        self.translatesAutoresizingMaskIntoConstraints=false
        self.text = str
        self.textAlignment = align
        self.textColor = color
        self.font = .systemFont(ofSize: size)
        self.numberOfLines = 0
    }
}

extension UITextField:UITextFieldDelegate{
    func setPlaceholder(str:String){
        self.attributedPlaceholder = NSAttributedString(string: str,attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) //().hexStringToUIColor(hex: "#332949")
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
