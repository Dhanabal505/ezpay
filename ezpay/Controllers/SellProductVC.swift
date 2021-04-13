//
//  SellProductVC.swift
//  ezpay
//
//  Created by Albert Charles on 13/04/21.
//

import UIKit

class SellProductVC: UIViewController {
    
    lazy var UserNamelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: .black, align: .center, size: 20)
        return lbl
    }()
    
    lazy var Userbalancelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: .black, align: .center, size: 20)
        return lbl
    }()
    
    lazy var AmountTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Purchase Amount", placeholder: "$")
        txt.txtField.keyboardType = .decimalPad
        return txt
    }()
    
    lazy var SellProduct:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Sell", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlesell), for: .touchUpInside)
        return btn
    }()
    
    var MerchantData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
        initialload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func SetSubViews(){
        view.addSubview(UserNamelbl)
        view.addSubview(Userbalancelbl)
        view.addSubview(AmountTxt)
        view.addSubview(SellProduct)
        
        setuplayout()
    }
    
    func initialload(){
        if UserModel.PCustomer?.balance != nil{
            Userbalancelbl.text = "User Wallet: $ \(UserModel.PCustomer!.balance)"
        }else{
            Userbalancelbl.text = "User Wallet: $ 0"
        }
        
        if UserModel.PCustomer?.name != nil && UserModel.PCustomer?.name?.count != 0{
            UserNamelbl.text = "User Name: \(UserModel.PCustomer!.name!)"
        }else{
            UserNamelbl.text = "User Name: "
        }
        
    }
    
    @objc func handlesell(){
        let strAmount = AmountTxt.txtField.text
        guard strAmount?.count != 0 else {
            self.makeToast(strMessage: "kindly provide the Purchased Money")
            return
        }
        
        if UserModel.PCustomer?.balance != nil{
            if UserModel.PCustomer!.balance < Double(strAmount!)! {
                self.makeToast(strMessage: "Insufficient fund")
                return
            }
        }
        
        let loader = LoaderView()
        loader.showLoader()
        let data = UserModel.PCustomer!
        
        let amount = data.balance - Double(strAmount!)!
        let adddata = ["name": data.name!,"balance": amount] as [String : Any]
        UserModel.ref.child("User").child(data.TagId).setValue(adddata)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            loader.hideLoader()
            let vc = MerchantDashVC()
            NavigationModel.redirectVC(to: vc)
        }
        
        
    }
    
    
}

extension SellProductVC{
    func setuplayout(){
        
        UserNamelbl.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: nil, bottom: nil, right: nil, padd: .init(top: -60, left: 0, bottom: 0, right: 0))
        
        Userbalancelbl.anchorWith_TopLeftBottomRight_Padd(top: UserNamelbl.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        AmountTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: nil, y: nil, top: Userbalancelbl.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 30, bottom: 0, right: -30))
        
        SellProduct.anchorWith_TopLeftBottomRight_Padd(top: AmountTxt.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 30, left: 20, bottom: 0, right: -20))
    }
}
