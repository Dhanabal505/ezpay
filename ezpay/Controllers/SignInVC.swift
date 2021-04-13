//
//  SignInVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit
import AuthenticationServices
import FirebaseDatabase
import GoogleSignIn

class SignInVC: UIViewController, GIDSignInDelegate{
    
    lazy var Googlesignup:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Google SignIn", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlegooglesignup), for: .touchUpInside)
        return btn
    }()
    
    lazy var AppleSignup:ASAuthorizationAppleIDButton={
        let btn = ASAuthorizationAppleIDButton()
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(handleApplesignup), for: .touchUpInside)
        btn.isHidden=true
        return btn
    }()
    
    var DonarData = [[String:Any]]()
    var Role = ""
    var RoleType = ""
    var MerchantData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetSubViews()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        UserModel.ref = Database.database().reference()
        DonarData.removeAll()
        
        RoleType = "\(LOCALSTORAGE.getLocalData(key: STR_UserDefault.Role)!)"
        if RoleType == "1" || RoleType == "2"{
            getFirebasedata(type: "Donar")
        }else if RoleType == "3"{
            getFirebasedata(type: "Merchant")
        }
    }
    
    
    
    func SetSubViews(){
        view.addSubview(Googlesignup)
        view.addSubview(AppleSignup)
        
        Setuplayout()
    }
    
    @objc func handlegooglesignup(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func handleApplesignup(){
        
        let AppleIDProvider = ASAuthorizationAppleIDProvider()
        let request = AppleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationvc = ASAuthorizationController(authorizationRequests: [request])
        authorizationvc.delegate = self
        authorizationvc.presentationContextProvider = self
        authorizationvc.performRequests()
        
    }
    
    func getFirebasedata(type:String){
        if type == "Donar"{
        UserModel.ref.child("Donar").observe(.childAdded, with: { (snapshot) in
             if let userDict = snapshot.value as? [String:Any] {
                var DonarID = ""
                var Email = ""
                var Balance = 0.00
                for data in userDict{
                    if let donarid =  snapshot.key as? String{
                        DonarID = donarid
                    }
                    if data.key == "mail"{
                        Email = (data.value as? String)!
                    }
                    if data.key == "balance"{
                        Balance = (data.value as? Double)!
                    }
                }
                let data = ["mail":Email,"balance":Balance,"DonarId":DonarID] as? [String:Any]
                self.DonarData.append(data!)
             }
        })
        }else if type == "Merchant"{
            UserModel.ref.child("Merchant").observe(.childAdded, with: { (snapshot) in
                
                 if let userDict = snapshot.value as? [String:Any] {
                    var MerchantID = ""
                    var Email = ""
                    if let merchantid =  snapshot.key as? String{
                        MerchantID = merchantid
                    }
                    for data in userDict{
                            if data.key == "mail"{
                                Email = (data.value as? String)!
                            }
                    }
                    let data = ["mail":Email] as? [String:Any]
                    self.MerchantData.append(data!)
                   
                 }
            })
        }
    }

    
    func AddorFetch(Email:String){
        var Newuser = true
        for data in DonarData{
            let email =  data["mail"] as? String
            if email == Email{
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
                if RoleType == "1"{
                if Email == "dhanabal.senthil@nissisoftwaresystems.com" || Email == "shapoursf@gmail.com"{
                    NavigationModel.redirectVC(to: vc)
                }else{
                    self.makeToast(strMessage: "Invalid Email")
                }
                }else if RoleType == "2"{
                    NavigationModel.redirectVC(to: vc)
                }
                
                return
            }
        }
        
        if Newuser == true{
            let DonarID = String(Date().currentTimeMillis())
            let data = ["mail": Email,"balance": 0] as [String : Any]
            UserModel.ref.child("Donar").child(DonarID).setValue(data)
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject:data)
                let user = try JSONDecoder().decode(Donar.self, from: jsonData!)
                UserModel.UserData = user
            }
            catch let error{
                print("Error - \(error)")
            }
            let vc = DashVC()
            NavigationModel.redirectVC(to: vc)
        }
        
    }
    
    func AddorFetchMerchant(Email:String){
        var Newuser = true
        for data in MerchantData{
            let email =  data["mail"] as? String
            if email == Email{
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
        
        if Newuser == true{
            let MerchantId = String(Date().currentTimeMillis())
            let data = ["mail": Email] as [String : Any]
            UserModel.ref.child("Merchant").child(MerchantId).setValue(data)
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject:data)
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

extension SignInVC{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(error)
        if error != nil{
            print(error)
            let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
        let name = user.profile.name
            LOCALSTORAGE.setLocalData(key: STR_UserDefault.Name, data: name)
        let email = user.profile.email
            if email?.count != 0 || email != nil{
                if RoleType == "1" || RoleType == "2"{
                    AddorFetch(Email: email!)
                }else if RoleType == "3"{
                    AddorFetchMerchant(Email: email!)
                }
            }
    }
    }
    
}

extension SignInVC:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            print(credentials.fullName)
            print(credentials.email)
        case let credentials as ASPasswordCredential:
            print(credentials.password)
        default:
            let alert = UIAlertController(title: "Apple SignIn", message: "Something went wrong with your apple ID", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension SignInVC:ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor{
        return view.window!
    }
    
}

extension SignInVC{
    func Setuplayout(){
        
        Googlesignup.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 50, bottom: 0, right: -50))
        
        AppleSignup.anchorWith_TopLeftBottomRight_Padd(top: Googlesignup.bottomAnchor, left: Googlesignup.leadingAnchor, bottom: nil, right: Googlesignup.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
    }
}
