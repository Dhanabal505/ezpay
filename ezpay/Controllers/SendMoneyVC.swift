//
//  SendMoneyVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit
import CoreNFC

class SendMoneyVC: UIViewController {
    
    lazy var AmountTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Enter Amount", placeholder: "$")
        txt.txtField.keyboardType = .decimalPad
        return txt
    }()
    
    lazy var AddMoney:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Send Money", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddmoney), for: .touchUpInside)
        return btn
    }()
    
    var MerchantData = [[String:Any]]()
    var CustomerData = [[String:Any]]()
    var SendAmnt = Double()
    var Customeraddamnt = Double()
    var Customerdata = [Customer]()

    var session:NFCTagReaderSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
     }
     
     override func viewWillAppear(_ animated: Bool) {
         setNavigation()
         navigationController?.navigationBar.isHidden = false
         navigationController?.interactivePopGestureRecognizer?.isEnabled = false
     }
     
     func SetSubViews(){
         view.addSubview(AmountTxt)
         view.addSubview(AddMoney)
         
         setuplayout()
     }
     
     @objc func handleAddmoney(){
         let strAmount = AmountTxt.txtField.text
         guard strAmount?.count != 0 else {
             self.makeToast(strMessage: "kindly provide the money")
             return
         }
        
        if UserModel.UserData?.balance != nil{
            if UserModel.UserData!.balance < Double(strAmount!)! {
                self.makeToast(strMessage: "Insufficient fund")
                return
            }
        }
        
        if !NFCNDEFReaderSession.readingAvailable {
            print("NFC Not available")
            self.makeToast(strMessage: "NFC Not Available")
            return
        }
           
       session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
       session.alertMessage = "Hold your NFC Tag"
       session.begin()
        
        self.Customeraddamnt = Double(strAmount!)!

     }
 }

 extension SendMoneyVC{
     func setuplayout(){
         AmountTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 30, bottom: 0, right: -30))
         
         AddMoney.anchorWith_TopLeftBottomRight_Padd(top: AmountTxt.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
     }
 }
@available(iOS 13.0, *)
extension SendMoneyVC:NFCTagReaderSessionDelegate{
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
                    var isvalid = false
                    DispatchQueue.main.async {
                        let nfcIDstr = identifier.hexEncodedString().uppercased()
                        if UserModel.CustomerData != nil{
                            print(UserModel.CustomerData)
                            for data in UserModel.CustomerData{
                                if data.TagId == nfcIDstr{
                                    isvalid = true
                                    let amount = data.balance + self.Customeraddamnt
                                    let adddata = ["name": data.name!,"balance": amount] as [String : Any]
                                    UserModel.ref.child("User").child(data.TagId).setValue(adddata)
                                    let balance = UserModel.UserData!.balance - self.Customeraddamnt
                                    UserModel.UserData!.balance = UserModel.UserData!.balance - self.Customeraddamnt
                                    let data = ["balance":balance,"Role":UserModel.UserData!.Role] as! [String:Any]
                                    UserModel.ref.child(UserModel.UserData!.UserId).setValue(data)
                                    session.alertMessage = "Money Send Successfully"
                                    session.invalidate()
                                    let vc = DashVC()
                                    NavigationModel.redirectVC(to: vc)
                                    return
                                }
                            }
                            if isvalid == false{
                            session.invalidate(errorMessage: "Invalid User")
                        }
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
extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
