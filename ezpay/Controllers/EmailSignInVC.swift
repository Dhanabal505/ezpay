//
//  EmailSignInVC.swift
//  ezpay
//
//  Created by Albert Charles on 15/04/21.
//

import UIKit

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
        //btn.addTarget(self, action: #selector(handleAddmoney), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
    }
    

}
