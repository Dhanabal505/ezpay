//
//  PaymentVC.swift
//  ezpay
//
//  Created by Albert Charles on 18/05/21.
//

import UIKit
import Firebase
import Stripe

class PaymentVC: UIViewController, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
        var paymentSheet: PaymentSheet?
        var paymentResult: PaymentResult?
        var isLoading = false
        var db = Firestore.firestore()
    var Amount = Double()
    var cardtextparams = STPPaymentMethodCardParams()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
   
    func preparePayment(uid: String, amount: Double, currency: String) {
    
        self.paymentSheet = nil
        self.paymentResult = nil
        self.Amount = amount
        self.isLoading = true
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("stripe_customers").document(uid).collection("payments").addDocument(data: [
            "currency": currency,
            "amount": amount*100
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        ref?.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            
            let customer = data["customer"]
            let ephemeralKey = data["ephemeralKey"]
            let clientSecret = data["client_secret"]
            print(clientSecret)
            if (customer != nil && ephemeralKey != nil && clientSecret != nil) {
                // MARK: Create a PaymentSheet instance
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Example, Inc."
                
                configuration.customer = .init(id: customer as! String, ephemeralKeySecret: ephemeralKey as! String)
                configuration.applePay = .init(merchantId: "merchant.com.ezpay.nissi", merchantCountryCode: "US")
                let loader = LoaderView()
                loader.showLoader()
                DispatchQueue.main.async {
                    if clientSecret != nil{
                    let paymentMethodParams = STPPaymentMethodParams(card: self.cardtextparams, billingDetails: nil, metadata: nil)
                        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret as! String)
                    paymentIntentParams.paymentMethodParams = paymentMethodParams
                    paymentIntentParams.setupFutureUsage = STPPaymentIntentSetupFutureUsage(rawValue: Int(NSNumber(value: STPPaymentIntentSetupFutureUsage.offSession.rawValue)))
                           
                    let paymentHandler = STPPaymentHandler.shared()
                    paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
                    switch (status) {
                        case .failed:
                            loader.hideLoader()
                            self.makeToast(strMessage: "Failed")
                            break
                        case .canceled:
                            loader.hideLoader()
                            self.makeToast(strMessage: "Cancel")
                            break
                        case .succeeded:
                            self.makeToast(strMessage: "Success")
                            let data = ["balance":self.Amount+UserModel.UserData!.balance,"Role":UserModel.UserData!.Role] as! [String:Any]
                            UserModel.ref.child(UserModel.UserData!.UserId).setValue(data)
                            UserModel.UserData?.balance = self.Amount+UserModel.UserData!.balance
                            self.makeToast(strMessage: "Money Added Successfully")
                            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                                loader.hideLoader()
                                let vc = DashVC()
                                NavigationModel.redirectVC(to: vc)
                                
                            }
                            break
                        @unknown default:
                            fatalError()
                            break
                        }
                    }
                    self.isLoading = false
                    }
                }
            }
        }
    
    
        func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentSheet = nil
            self.paymentResult = result
    }
}
}


