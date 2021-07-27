//
//  EmailSignUPVC.swift
//  ezpay
//
//  Created by Albert Charles on 15/04/21.
//

import UIKit
import FirebaseAuth

class EmailSignUpVC: UIViewController {

    lazy var EmailTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Email", placeholder: "Enter your email address")
        return txt
    }()
    
    lazy var PassTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Password", placeholder: "Enter your password")
        return txt
    }()
    
    lazy var SignUp:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "SignUp", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlesignup), for: .touchUpInside)
        return btn
    }()
    
    lazy var SignIn:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Already have an account? SignIn", bgColor: .clear, textColor: COLORS.BorderColor)
        btn.addTarget(self, action: #selector(handlesignin), for: .touchUpInside)
        btn.layer.borderWidth = 0
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
    }
    
    func SetSubViews(){
        view.addSubview(EmailTxt)
        view.addSubview(PassTxt)
        view.addSubview(SignUp)
        view.addSubview(SignIn)
        
        setuplayout()
    }
    
    @objc func handlesignup(){
        let strEmail = EmailTxt.txtField.text?.trim()
        let strPass = PassTxt.txtField.text?.trim()
        
        if strEmail?.count == 0{
            self.makeToast(strMessage: "Enter the email address")
            return
        }
        
        if strPass?.count == 0{
            self.makeToast(strMessage: "Enter the password")
            return
        }
        
        if !isValidEmail(email: strEmail!){
            self.makeToast(strMessage: "Invalid Email")
            return
        }
        let loader = LoaderView()
        loader.showLoader()
        FirebaseAuth.Auth.auth().createUser(withEmail: strEmail!, password: strPass!, completion: { result, error in
            loader.hideLoader()
            guard error == nil else{
                self.handleError(error!)
                return
            }
            
            self.makeToast(strMessage: "Account Created Successfully")
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                            NavigationModel.popViewController()
                        } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                        }
                
            }
        })
        
    }
    
    @objc func handlesignin(){
        let vc = EmailSignInVC()
        NavigationModel.redirectVC(to: vc)
    }
    
//    func createaccount(Email:String, Pass: String){
//        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
//        let Continue = UIAlertAction(title: "Continue", style: .default) { (actions) in
//            FirebaseAuth.Auth.auth().createUser(withEmail: Email, password: Pass, completion: { result, error in
//                guard error == nil else{
//                    self.makeToast(strMessage: "Account Created Failed")
//                    return
//                }
//
//                self.makeToast(strMessage: "Account Created Successfully")
//            })
//         }
//        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(Continue)
//        alert.addAction(Cancel)
//        self.present(alert, animated: true, completion: nil)
//    }

}

extension EmailSignUpVC{
    func setuplayout(){
        EmailTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: -100, left: 30, bottom: 0, right: -30))
        
        PassTxt.anchorWith_TopLeftBottomRight_Padd(top: EmailTxt.bottomAnchor, left: EmailTxt.leadingAnchor, bottom: nil, right: EmailTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        SignUp.anchorWith_TopLeftBottomRight_Padd(top: PassTxt.bottomAnchor, left: PassTxt.leadingAnchor, bottom: nil, right: PassTxt.trailingAnchor, padd: .init(top: 40, left: 20, bottom: 0, right: -20))
        
        SignIn.anchorWith_TopLeftBottomRight_Padd(top: SignUp.bottomAnchor, left: PassTxt.leadingAnchor, bottom: nil, right: PassTxt.trailingAnchor, padd: .init(top: 40, left: 20, bottom: 0, right: -20))
    }
}
