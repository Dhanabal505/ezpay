//
//  AddMoneyVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit

class AddMoneyVC: UIViewController {
    
    lazy var AmountTxt:CustomHeaderTXT={
        let txt = CustomHeaderTXT(header: "Enter Amount", placeholder: "$")
        txt.txtField.keyboardType = .decimalPad
        return txt
    }()
    
    lazy var AddMoney:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Add your Wallet", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddmoney), for: .touchUpInside)
        return btn
    }()
    
    var DonarData = [[String:Any]]()

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
        print(strAmount!)
        var Amnt = 0.00
        if UserModel.UserData?.balance != nil{
            Amnt = Double(strAmount!)!+UserModel.UserData!.balance
        }else{
            Amnt = Double(strAmount!)!
        }
        
        let data = ["mail":UserModel.UserData?.mail,"balance":Amnt] as! [String:Any]
        UserModel.ref.child("Donar").child(UserModel.UserData!.DonarId).setValue(data)
        UserModel.UserData?.balance = Amnt
        let loader = LoaderView()
        loader.showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            loader.hideLoader()
            self.makeToast(strMessage: "Money Added Successfully")
            let vc = DashVC()
            NavigationModel.redirectVC(to: vc)
            
        }
        
    }
}

extension AddMoneyVC{
    func setuplayout(){
        AmountTxt.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 30, bottom: 0, right: -30))
        
        AddMoney.anchorWith_TopLeftBottomRight_Padd(top: AmountTxt.bottomAnchor, left: AmountTxt.leadingAnchor, bottom: nil, right: AmountTxt.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
    }
}
