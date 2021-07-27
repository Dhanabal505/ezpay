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
import FirebaseAuth

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
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
extension String{
    func trim()->String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again."
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        }
    }
    
    

}

