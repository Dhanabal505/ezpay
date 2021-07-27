//
//  SignInVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit
import AuthenticationServices
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import CryptoKit

class SignInVC: UIViewController{ //, GIDSignInDelegate
    
    lazy var Googlesignup:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "SignIn with Email", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlesign), for: .touchUpInside)
        return btn
    }()
    
    lazy var AppleSignup:ASAuthorizationAppleIDButton={
        let btn = ASAuthorizationAppleIDButton()
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(handleApple), for: .touchDown)
        return btn
    }()
    
    var DonarData = [[String:Any]]()
    var Role = ""
    var RoleType = ""
    var MerchantData = [[String:Any]]()
    fileprivate var currentNonce: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetSubViews()

    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        UserModel.ref = Database.database().reference()
        DonarData.removeAll()
        getFirebasedata()
        
       
    }
    
    
    
    func SetSubViews(){
        view.addSubview(Googlesignup)
        view.addSubview(AppleSignup)
        
        Setuplayout()
    }
    
    @objc func handlesign(){
        let vc = EmailSignInVC()
        vc.Role = Role
        NavigationModel.redirectVC(to: vc)
    }
    
    @objc func handleApple(){
        let request = createAppleIDreuest()
        let authorizationvc = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationvc.delegate = self
        authorizationvc.presentationContextProvider = self
        authorizationvc.performRequests()
    }
    
    func createAppleIDreuest() -> ASAuthorizationAppleIDRequest{
        let AppleIDProvider = ASAuthorizationAppleIDProvider()
        let request = AppleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
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

extension SignInVC:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let AppleIDcredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else{
                fatalError("Invalid State")
            }
            guard let AppleIDToken = AppleIDcredential.identityToken else{
                print("unable to fetch Id token")
                return
            }
            guard let idtokenstring = String(data: AppleIDToken, encoding: .utf8) else{
                print("unable to get id")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idtokenstring, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authdataresult, error) in
                if let user = authdataresult?.user {
                    print("Signe in with uid: \(user.uid), email: \(user.displayName)")
                    self.AddorFetch(Userid: user.uid)
                }
            }
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
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
        AppleSignup.anchorWith_Height(height: nil, const: 50)
        
    }
}



