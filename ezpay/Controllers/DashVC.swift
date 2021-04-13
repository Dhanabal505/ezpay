//
//  MainVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit

class DashVC: UIViewController {
    
    lazy var Welcomelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "Welcome", color: .black, align: .center, size: 24)
        return lbl
    }()
    
    lazy var Namelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: COLORS.BorderColor, align: .center, size: 18)
        return lbl
    }()
    
    lazy var Mybalancelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: .black, align: .center, size: 20)
        return lbl
    }()
    
    lazy var AddMoney:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Add Money", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddMoney), for: .touchUpInside)
        return btn
    }()
    
    lazy var SendMoney:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Send Money", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handlesendMoney), for: .touchUpInside)
        return btn
    }()
    
    lazy var AddUser:CustomFormBTNs={
        let btn = CustomFormBTNs(title: "Add User", bgColor: .lightGray, textColor: .black)
        btn.addTarget(self, action: #selector(handleAddUserVC), for: .touchUpInside)
        return btn
    }()
    
    lazy var LogoutBtn:CustomImgBTN={
        let btn = CustomImgBTN(img: UIImage(named: "logout_Icon")!)
        btn.addTarget(self, action: #selector(handlelogout), for: .touchUpInside)
        return btn
    }()

    var CustomerData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
        initialload()
        
        let Role = "\(LOCALSTORAGE.getLocalData(key: STR_UserDefault.Role)!)"
        if Role == "1"{
            AddUser.isHidden = false
        }else{
            AddUser.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        GetFirebaseusers()
    }
    
    func SetSubViews(){
        view.addSubview(Welcomelbl)
        view.addSubview(Namelbl)
        view.addSubview(Mybalancelbl)
        view.addSubview(SendMoney)
        view.addSubview(AddMoney)
        view.addSubview(AddUser)
        view.addSubview(LogoutBtn)
        
        setuplayout()
    }
    
    func initialload(){
        let name = "\(LOCALSTORAGE.getLocalData(key: STR_UserDefault.Name)!)"
        Namelbl.text = name
        if UserModel.UserData?.balance != nil{
            Mybalancelbl.text = "Wallet Money: $\(UserModel.UserData!.balance)"
        }else{
            Mybalancelbl.text = "Wallet Money: $0"
        }
    }
    
    @objc func handleAddMoney(){
        let vc = AddMoneyVC()
        NavigationModel.redirectVC(to: vc)
    }
    
    @objc func handlesendMoney(){
        let vc = SendMoneyVC()
        NavigationModel.redirectVC(to: vc)
    }
    
    @objc func handleAddUserVC(){
        let vc = UserVC()
        NavigationModel.redirectVC(to: vc)
    }
    
    @objc func handlelogout(){
        let vc = MainVC()
        NavigationModel.redirectVC(to: vc)
    }
    
    func GetFirebaseusers(){
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

extension DashVC{
    func setuplayout(){
        Welcomelbl.anchorWith_TopLeftBottomRight_Padd(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        Namelbl.anchorWith_TopLeftBottomRight_Padd(top: Welcomelbl.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        Mybalancelbl.anchorWith_XY_TopLeftBottomRight_Padd(x: nil, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: nil, padd: .init(top: -60, left: 30, bottom: 0, right: 0))
        
        AddMoney.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 20, bottom: 0, right: -20))
        
        SendMoney.anchorWith_TopLeftBottomRight_Padd(top: AddMoney.bottomAnchor, left: AddMoney.leadingAnchor, bottom: nil, right: AddMoney.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        AddUser.anchorWith_TopLeftBottomRight_Padd(top: SendMoney.bottomAnchor, left: AddMoney.leadingAnchor, bottom: nil, right: AddMoney.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        LogoutBtn.anchorWith_TopLeftBottomRight_Padd(top: Welcomelbl.topAnchor, left: nil, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 0, bottom: 0, right: -20))
        LogoutBtn.anchorWith_WidthHeight(width: nil, height: nil, constWidth: 30, constHeight: 30)
    }
}
