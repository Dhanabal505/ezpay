//
//  UserVC.swift
//  ezpay
//
//  Created by Albert Charles on 09/04/21.
//

import UIKit
import CoreNFC

class UserVC: UIViewController {
    
    lazy var NameTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "User Name", placeholder: "")
        return txt
    }()
    
    lazy var AmountTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Enter Amount", placeholder: "$")
        txt.txtField.keyboardType = .decimalPad
        return txt
    }()
    
    lazy var AddUser:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Activate User", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        return btn
    }()
    
    var Name = ""
    var Amount = 0.00
    var CustomerData = [[String:Any]]()
    
    var session:NFCTagReaderSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
        getFirebasecustomerdata(TagID: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func SetSubViews(){
        view.addSubview(NameTxt)
        view.addSubview(AmountTxt)
        view.addSubview(AddUser)
        
        setuplayout()
    }
    
    
    @objc func handleAddUser(){
        let strusername = NameTxt.txtField.text
        
        
        guard strusername?.count != 0 else{
            self.makeToast(strMessage: "Kindly Provide the Username")
            return
        }
        
        self.Name = strusername!
        
        let strAmount = AmountTxt.txtField.text
        if strAmount?.count != 0 {
            self.Amount = Double(strAmount!)!
        }
        
        if UserModel.UserData?.balance != nil{
            if UserModel.UserData!.balance < Double(strAmount!)! {
                self.makeToast(strMessage: "Insufficient fund")
                return
            }
        }
        
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        session.alertMessage = "Hold your NFC Tag"
        session.begin()
    }
    
    func getFirebasecustomerdata(TagID:String){
        
        UserModel.ref.child("User").observe(.childAdded, with: { (snapshot) in
            
             if let userDict = snapshot.value as? [String:Any] {
                var TagId = ""
                var Name = ""
                var Balance = 0
                if let customerid =  snapshot.key as? String{
                    TagId = customerid
                }
                for data in userDict{
                        if data.key == "name"{
                            Name = (data.value as? String)!
                        }
                        if data.key == "balance" {
                            Balance = (data.value as? Int)!
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
//        let loader = LoaderView()
//        loader.showLoader()
//        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//            loader.hideLoader()
//            self.makeToast(strMessage: "Money Added Successfully")
//            let vc = DashVC()
//            NavigationModel.redirectVC(to: vc)
//        }
        
    }

   
}

extension UserVC{
    func setuplayout(){
        NameTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: -50, left: 30, bottom: 0, right: -30))
        
        AmountTxt.anchorWith_TopLeftBottomRight_Padd(top: NameTxt.bottomAnchor, left: NameTxt.leadingAnchor, bottom: nil, right: NameTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        AddUser.anchorWith_TopLeftBottomRight_Padd(top: AmountTxt.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 30, left: 20, bottom: 0, right: -20))
    }
}

@available(iOS 13.0, *)
extension UserVC:NFCTagReaderSessionDelegate{
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
                    let nfcIDstr = identifier.hexEncodedString().uppercased()
                    var NewUser = true
                    if UserModel.CustomerData != nil{
                        for data in UserModel.CustomerData{
                            if data.TagId == nfcIDstr{
                                NewUser = false
                                session.invalidate(errorMessage: "This Band Already Associated with i8another User")
                            }
                        }
                    }
                    if NewUser == true{
                    let data = ["name": self.Name,"balance": self.Amount] as [String : Any]
                    UserModel.ref.child("User").child(nfcIDstr).setValue(data)
                        let balance = UserModel.UserData!.balance - self.Amount
                        UserModel.UserData!.balance = UserModel.UserData!.balance - self.Amount
                        let datas = ["balance":balance] as! [String:Any]
                        UserModel.ref.child("Donar").child(UserModel.UserData!.UserId).setValue(datas)
                        session.alertMessage = "User Added Successfully"
                        session.invalidate()
                        DispatchQueue.main.async {
                            let vc = DashVC()
                            NavigationModel.redirectVC(to: vc)
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

