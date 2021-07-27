//
//  CheckController.swift
//  ezpay
//
//  Created by Albert Charles on 18/05/21.
//

import UIKit
import Stripe
import FirebaseAuth

class CheckoutViewController: UIViewController{

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
    
    var paymentIntentClientSecret: String?
    var Amount = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
        ])
        
        setTapGesture()
    }
    
    
    
    @objc func pay() {
        view.endEditing(true)
        let cardParams = STPCardParams()
        cardParams.number = cardTextField.cardNumber
        cardParams.expMonth = UInt(cardTextField.expirationMonth)
        cardParams.expYear = UInt(cardTextField.expirationYear)
        cardParams.cvc = cardTextField.cvc
        
        guard cardParams.number?.count != 0 && cardParams.number != nil else {
            self.makeToast(strMessage: "please provide the card number")
            return
        }
        if cardParams.number != "4242424242424242"{
            self.makeToast(strMessage: "please provide the valid card number")
            return
        }
        if cardParams.number?.count != 16{
            self.makeToast(strMessage: "please provide the valid card number")
            return
        }
        guard cardParams.expMonth != 0 else {
            self.makeToast(strMessage: "please provide the exp Month")
            return
        }
        guard cardParams.expYear != 0 else {
            self.makeToast(strMessage: "please provide the exp Year")
            return
        }
        guard cardParams.cvc?.count != 0 && cardParams.cvc != nil else {
            self.makeToast(strMessage: "please provide the exp Month")
            return
        }

           let paymentIntentClientSecrets = paymentIntentClientSecret
                var Amnt = Amount
                let vc = PaymentVC()
                var uid = Auth.auth().currentUser!.uid
        vc.cardtextparams = cardTextField.cardParams
        vc.preparePayment(uid: uid, amount: Amnt, currency: "usd")
       
        }
}

extension CheckoutViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

