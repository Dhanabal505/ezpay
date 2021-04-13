//
//  MainVC.swift
//  ezpay
//
//  Created by Albert Charles on 13/04/21.
//

import UIKit

class MainVC: UIViewController {
    
    lazy var AdminBtn:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Admin", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleaction(sender:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var DonarBtn:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Donar", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleaction(sender:)), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    lazy var MerchantBtn:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Merchant", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleaction(sender:)), for: .touchUpInside)
        btn.tag = 3
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func SetSubViews(){
        view.addSubview(AdminBtn)
        view.addSubview(DonarBtn)
        view.addSubview(MerchantBtn)
        
        setuplayout()
    }
    
    @objc func handleaction(sender:UIButton){
        let vc = SignInVC()
        if sender.tag == 1{
            vc.Role = "Admin"
        }
        if sender.tag == 2{
            vc.Role = "Donar"
        }
        if sender.tag == 3{
            vc.Role = "Merchant"
        }
        LOCALSTORAGE.setLocalData(key: STR_UserDefault.Role, data: sender.tag)
        NavigationModel.redirectVC(to: vc)
    }
    
}
extension MainVC{
    func setuplayout(){
        AdminBtn.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: -60, left: 40, bottom: 0, right: -40))
        
        DonarBtn.anchorWith_TopLeftBottomRight_Padd(top: AdminBtn.bottomAnchor, left: AdminBtn.leadingAnchor, bottom: nil, right: AdminBtn.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        MerchantBtn.anchorWith_TopLeftBottomRight_Padd(top: DonarBtn.bottomAnchor, left: AdminBtn.leadingAnchor, bottom: nil, right: AdminBtn.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
    }
}
