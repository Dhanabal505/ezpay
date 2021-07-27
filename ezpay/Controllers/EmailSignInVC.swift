//
//  EmailSignInVC.swift
//  ezpay
//
//  Created by Albert Charles on 15/04/21.
//

import UIKit
import FirebaseAuth

class EmailSignInVC: UIViewController {

    lazy var EmailTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Email", placeholder: "Enter your email address")
        return txt
    }()
    
    lazy var PassTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Password", placeholder: "Enter your password")
        return txt
    }()
    
    lazy var SignIn:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "SignIn", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlesignin), for: .touchUpInside)
        return btn
    }()
    
    lazy var SignUp:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Don't have an Account? SignUp", bgColor: .clear, textColor: COLORS.BorderColor)
        btn.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        btn.layer.borderWidth = 0
        return btn
    }()
    
    var DonarData = [[String:Any]]()
    var Role = ""
    var RoleType = ""
    var MerchantData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
        
        getFirebasedata()
    }
    
    func SetSubViews(){
        view.addSubview(EmailTxt)
        view.addSubview(PassTxt)
        view.addSubview(SignIn)
        view.addSubview(SignUp)
        
        setuplayout()
    }
    
    @objc func handlesignin(){
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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: strEmail!, password: strPass!, completion: { result, error in
            guard error == nil else{
                print(error!._code)
                self.handleError(error!)
                return
            }
            self.AddorFetch(Userid: result!.user.uid)
        })
        
    }
    
    @objc func handleSignup(){
        EmailTxt.txtField.text = ""
        PassTxt.txtField.text = ""
        let vc = EmailSignUpVC()
        NavigationModel.redirectVC(to: vc)
    }
    
    func getFirebasedata(){
        UserModel.ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.key != "User"{
             if let userDict = snapshot.value as? [String:Any] {
                var UserID = ""
                var Balance = 0.00
                var Role = ""
                for data in userDict{
                    if let userid =  snapshot.key as? String{
                        UserID = userid
                    }
                    if data.key == "Role"{
                        Role = data.value as! String
                    }
                    if data.key == "balance"{
                        Balance = (data.value as? Double)!
                    }
                }
                if Role == "Admin" || Role == "Donar"{
                    let data = ["Role":Role,"balance":Balance,"UserId":UserID] as? [String:Any]
                    self.DonarData.append(data!)
                }else{
                    let data = ["Role":Role,"UserId":UserID] as? [String:Any]
                    self.MerchantData.append(data!)
                }
             }
            }
        })
    }

    
    func AddorFetch(Userid:String){
        var Newuser = true
        for data in DonarData{
            let userid =  data["UserId"] as? String
            if userid == Userid{
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject:data)
                    let user = try JSONDecoder().decode(Donar.self, from: jsonData!)
                    UserModel.UserData = user
                   
                }
                catch let error{
                    print("Error - \(error)")
                }
                Newuser = false
                let vc = DashVC()
                vc.isSignin = true
                NavigationModel.redirectVC(to: vc)
                return
            }
        }
        
        for data in MerchantData{
            let userId =  data["UserId"] as? String
            if userId == Userid{
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject:data)
                    let user = try JSONDecoder().decode(Merchant.self, from: jsonData!)
                    UserModel.MerchantData = user
                   
                }
                catch let error{
                    print("Error - \(error)")
                }
                Newuser = false
                let vc = MerchantDashVC()
                NavigationModel.redirectVC(to: vc)
                return
            }
        }
        
        if self.Role == "Admin" || self.Role == "Donar"{
        if Newuser == true{
            let data = ["Role":self.Role,"balance": 0.0] as [String : Any]
            UserModel.ref.child(Userid).setValue(data)
            let datas = ["Role":self.Role,"balance": 0.0,"UserId":Userid] as [String : Any]
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject:datas)
                let user = try JSONDecoder().decode(Donar.self, from: jsonData!)
                UserModel.UserData = user
            }
            catch let error{
                print("Error - \(error)")
            }
            let vc = DashVC()
            vc.isSignin = true
            NavigationModel.redirectVC(to: vc)
        }
        }else{
            if Newuser == true{
                let data = ["Role":"Merchant"] as [String:String]
                UserModel.ref.child(Userid).setValue(data)
                let datas = ["Role":"Merchant","UserId": Userid] as [String:String]
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject:datas)
                    let user = try JSONDecoder().decode(Merchant.self, from: jsonData!)
                    UserModel.MerchantData = user
                }
                catch let error{
                    print("Error - \(error)")
                }
                let vc = MerchantDashVC()
                NavigationModel.redirectVC(to: vc)
            }
        }
        
    }

    
}

extension EmailSignInVC{
    func setuplayout(){
        EmailTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: -100, left: 30, bottom: 0, right: -30))
        
        PassTxt.anchorWith_TopLeftBottomRight_Padd(top: EmailTxt.bottomAnchor, left: EmailTxt.leadingAnchor, bottom: nil, right: EmailTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        SignIn.anchorWith_TopLeftBottomRight_Padd(top: PassTxt.bottomAnchor, left: PassTxt.leadingAnchor, bottom: nil, right: PassTxt.trailingAnchor, padd: .init(top: 40, left: 20, bottom: 0, right: -20))
        
        SignUp.anchorWith_TopLeftBottomRight_Padd(top: SignIn.bottomAnchor, left: PassTxt.leadingAnchor, bottom: nil, right: PassTxt.trailingAnchor, padd: .init(top: 40, left: 20, bottom: 0, right: -20))
    }
}
