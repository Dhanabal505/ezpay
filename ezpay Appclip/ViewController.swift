//
//  ViewController.swift
//  ezpay Appclip
//
//  Created by Albert Charles on 20/07/21.
//


import UIKit
import PassKit
//import Stripe
//import FirebaseAuth

class SendMoneyVC: UIViewController{   //,STPApplePayContextDelegate, STPAddCardViewControllerDelegate{
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
//        print(paymentMethod)
//        self.dismiss(animated: true, completion: {
//        })
//    }
//
    
    
    
//    lazy var AmountTxt:CustomHeaderTXT={
//        let txt = CustomHeaderTXT(header: "Enter Amount", placeholder: "$")
//        txt.txtField.keyboardType = .decimalPad
//        return txt
//    }()
//
//    lazy var AddMoney:PKPaymentButton={
//        var btn = PKPaymentButton()
//        if #available(iOS 14.0, *) {
//            btn = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
//        } else {
//            btn = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
//        }
//        btn.translatesAutoresizingMaskIntoConstraints=false
//        btn.addTarget(self, action: #selector(handleApplePaymoney), for: .touchUpInside)
//        return btn
//    }()
    
//    lazy var CardPaymentBtn:CustomFormBTNs={
//        let btn = CustomFormBTNs(title: "Card Payment", bgColor: .lightGray, textColor: .black)
//      //  btn.addTarget(self, action: #selector(handleCardPayButtonTapped), for: .touchUpInside)
//        return btn
//    }()
    
    lazy var paymetrequest : PKPaymentRequest={
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.ezpay.nissi"
        request.supportedNetworks = [.quicPay, .masterCard,.visa]
        request.supportedCountries = ["IN","US"]
        request.merchantCapabilities = .capability3DS
        
        request.countryCode = "IN"
        request.currencyCode = "INR"
        
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Add to Wallet", amount: 50)]
        return request
    }()
    
    var DonarData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

       SetSubViews()
     //   print(StripeAPI.deviceSupportsApplePay())
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func SetSubViews(){
//        view.addSubview(AmountTxt)
//        view.addSubview(AddMoney)
      //  view.addSubview(CardPaymentBtn)
        
        setuplayout()
    }
    
//    @objc func handleApplePaymoney(){
//        let strAmount = AmountTxt.txtField.text
//        guard strAmount?.count != 0 else {
//         //   self.makeToast(strMessage: "kindly provide the money")
//            return
//        }
//
//        var money = NSDecimalNumber(string: strAmount!)
//
//        let merchantIdentifier = "merchant.com.ezpay.nissi"
//         //   let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
//
//            // Configure the line items on the payment request
////            paymentRequest.paymentSummaryItems = [
////                // The final line should represent your company;
////                // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
////                PKPaymentSummaryItem(label: "Example, Inc", amount: money),
////            ]
////
////        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
////                // Present Apple Pay payment sheet
////                applePayContext.presentApplePay(on: self)
////            } else {
////                // There is a problem with your Apple Pay configuration
////            }
//
//    }
    
//    @objc func handleCardPayButtonTapped() {
//        let strAmount = AmountTxt.txtField.text
//        guard strAmount?.count != 0 else {
//            self.makeToast(strMessage: "kindly provide the money")
//            return
//        }
//        let addCardViewController = CheckoutViewController()
//        addCardViewController.Amount = Double(strAmount!)!
//        NavigationModel.redirectVC(to: addCardViewController)
//
//    }
    
    
}

extension SendMoneyVC{
//    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
//        print("create")
//    }
//
//    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
//        print(status)
//        print(error)
//    }
    
}

extension SendMoneyVC{
    func setuplayout(){
//        AmountTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 30, bottom: 0, right: -30))
//        
//        AddMoney.anchorWith_TopLeftBottomRight_Padd(top: AmountTxt.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
//        AddMoney.anchorWith_Height(height: nil, const: 50)
        
//        CardPaymentBtn.anchorWith_TopLeftBottomRight_Padd(top: AddMoney.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 20, left: 0, bottom: 0, right: 0))
//        CardPaymentBtn.anchorWith_Height(height: nil, const: 50)
    }
}
extension SendMoneyVC : PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //self.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
//extension CheckoutViewController {
//    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
//        print(paymentInformation.token)
////        let clientSecret =  // Retrieve the PaymentIntent client secret from your backend (see Server-side step above)
////        // Call the completion block with the client secret or an error
////        completion(clientSecret, error);
//    }
//
//    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
//          switch status {
//        case .success:
//            // Payment succeeded, show a receipt view
//            break
//        case .error:
//            // Payment failed, show the error
//            break
//        case .userCancellation:
//            // User cancelled the payment
//            break
//        @unknown default:
//            fatalError()
//        }
//    }
//}
