//
//  MerchantDashVC.swift
//  ezpay
//
//  Created by Albert Charles on 13/04/21.
//

import UIKit
import CoreNFC
import FirebaseAuth

class MerchantDashVC: UIViewController {
    
    lazy var Welcomelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "Welcome", color: .black, align: .center, size: 24)
        return lbl
    }()
    
    lazy var Namelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: COLORS.BorderColor, align: .center, size: 18)
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var Mybalancelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: .black, align: .center, size: 20)
        return lbl
    }()
    
    lazy var AddMoney:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Get User", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddMoney), for: .touchUpInside)
        return btn
    }()
    
    lazy var LogoutBtn:CustomImgBTN={
        let btn = CustomImgBTN(img: UIImage(named: "logout_Icon")!)
        btn.addTarget(self, action: #selector(handlelogout), for: .touchUpInside)
        return btn
    }()
    
    var CustomerData = [[String:Any]]()
    
    var session:NFCTagReaderSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        GetfirebaseusersData()
    }
    
    func SetSubViews(){
        view.addSubview(Welcomelbl)
        view.addSubview(Namelbl)
        view.addSubview(Mybalancelbl)
        view.addSubview(AddMoney)
        view.addSubview(LogoutBtn)
        
        setuplayout()
    }
    
    @objc func handleAddMoney(){
        if !NFCNDEFReaderSession.readingAvailable {
            print("NFC Not available")
            self.makeToast(strMessage: "NFC Not Available")
            return
        }
           
       session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
       session.alertMessage = "Hold your NFC Tag"
       session.begin()
    }
    
    @objc func handlelogout(){
            let alert = UIAlertController(title: "Signout!", message: "Are you really want to Signout?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (actions) in
                let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                            let vc = MainVC()
                            NavigationModel.redirectVC(to: vc)
                        } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                        }
            }
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
      
    }
    
    func GetfirebaseusersData(){
        UserModel.ref.child("User").observe(.childAdded, with: { (snapshot) in
                    
                     if let userDict = snapshot.value as? [String:Any] {
                        var TagId = ""
                        var Name = ""
                        var Balance = 0.00
                        if let customerid =  snapshot.key as? String{
                            TagId = customerid
                        }
                        for data in userDict{
                                if data.key == "name"{
                                    Name = (data.value as? String)!
                                }
                                if data.key == "balance" {
                                    Balance = (data.value as? Double)!
                                }
                            
                        }
                        let data = ["name":Name,"balance":Balance,"TagId":TagId] as? [String:Any]
                        self.CustomerData.append(data!)
                        print(self.CustomerData)
                     }
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject:self.CustomerData)
                    let user = try JSONDecoder().decode([Customer].self, from: jsonData!)
                    UserModel.CustomerData = user
                }
                catch let error{
                    print("Error - \(error)")
                }
            })
    }


}

extension MerchantDashVC{
    func setuplayout(){
        Welcomelbl.anchorWith_TopLeftBottomRight_Padd(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        Namelbl.anchorWith_TopLeftBottomRight_Padd(top: Welcomelbl.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        Mybalancelbl.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: nil, padd: .init(top: -60, left: 0, bottom: 0, right: 0))
        
        AddMoney.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 20, bottom: 0, right: -20))
        
        LogoutBtn.anchorWith_TopLeftBottomRight_Padd(top: Welcomelbl.topAnchor, left: nil, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 0, bottom: 0, right: -20))
        LogoutBtn.anchorWith_WidthHeight(width: nil, height: nil, constWidth: 30, constHeight: 30)
    }
}

@available(iOS 13.0, *)
extension MerchantDashVC:NFCTagReaderSessionDelegate{
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("didInvalidateWithError")

        session.invalidate()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {

        let tag = tags.first!
        
        session.connect(to: tag) { (error) in
            if error != nil{
                print("error occure")
                session.restartPolling()
                return
            }
            
            if case let NFCTag.iso7816(tag) = tag{
                print("Card ios7816")
            }
            else if case let NFCTag.miFare(tag) = tag{
                print("Card MiFare -- \(tag.identifier)")
                
                if let identifier = tag.identifier as? Data {
                    print("Card Tag ID = \(identifier.hexEncodedString().uppercased())")
                    var Invalid = true
                    DispatchQueue.main.async {
                        let nfcIDstr = identifier.hexEncodedString().uppercased()
                        if UserModel.CustomerData != nil{
                            for data in UserModel.CustomerData{
                                if data.TagId == nfcIDstr{
                                    Invalid = false
                                    UserModel.PCustomer = data
                                    session.alertMessage = "User Found Successfully"
                                    session.invalidate()
                                    
                                }
                            }
                            if Invalid == false{
                                let vc = SellProductVC()
                                NavigationModel.redirectVC(to: vc)
                            }else if Invalid == true{
                                session.invalidate(errorMessage: "Invalid User")
                            }
                        }
                        if Invalid == true{
                            session.invalidate(errorMessage: "Invalid User")
                        }
                        
                    }
                }
            }
            else{
                print("Some Other Card")
                session.invalidate(errorMessage: "Invalid Card")
            }
        }
    }
}
