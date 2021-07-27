//
//  MainVC.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashVC: UIViewController {
    
    lazy var Welcomelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "Welcome", color: .black, align: .center, size: 24)
        return lbl
    }()
    
    lazy var Namelbl:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: COLORS.BorderColor, align: .center, size: 18)
        lbl.isHidden = true
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

    var isSignin = false
    var CustomerData = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        SetSubViews()
        getFirebasecustomerdata(TagID: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        initialload()
        
    }
    
    func SetSubViews(){
        view.addSubview(Welcomelbl)
        view.addSubview(Mybalancelbl)
        view.addSubview(SendMoney)
        view.addSubview(AddMoney)
        view.addSubview(AddUser)
        view.addSubview(LogoutBtn)
        
        setuplayout()
    }
    
    func initialload(){
        let view = LoaderView()
        view.showLoader()
        if isSignin == false{
        UserModel.ref = Database.database().reference()
        let userid = Auth.auth().currentUser!.uid
            print(userid)
        UserModel.ref.observe(.childAdded, with: { (snapshot) in
            if userid == snapshot.key{
                if let userDict = snapshot.value as? [String:Any] {
                   var UserID = ""
                   var Balance = 0.00
                   var Role = ""
                   for data in userDict{
                       if let userid =  snapshot.key as? String{
                           UserID = userid
                       }
                       if data.key == "Role"{
                           Role = data.value as! String
                       }
                       if data.key == "balance"{
                           Balance = (data.value as? Double)!
                       }
                   }
                   let data = ["Role":Role,"balance":Balance,"UserId":UserID] as? [String:Any]
                    do {
                        let jsonData = try? JSONSerialization.data(withJSONObject:data)
                        let user = try JSONDecoder().decode(Donar.self, from: jsonData!)
                        UserModel.UserData = user
                    }
                    catch let error{
                        print("Error - \(error)")
                    }
                    if UserModel.UserData!.Role == "Admin"{
                        self.AddUser.isHidden = false
                    }else{
                        self.AddUser.isHidden = true
                    }
                    self.Mybalancelbl.text = "My Wallet : $\(UserModel.UserData!.balance)"
                    
                    view.hideLoader()
                }
            }
        })
        }else{
            if UserModel.UserData!.Role == "Admin"{
                self.AddUser.isHidden = false
            }else{
                self.AddUser.isHidden = true
            }
            self.Mybalancelbl.text = "My Wallet : $\(UserModel.UserData!.balance)"
            view.hideLoader()
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
            let alert = UIAlertController(title: "Signout!", message: "Are you really want to Signout?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (actions) in
                let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                            let vc = MainVC()
                            NavigationModel.redirectVC(to: vc)
                        } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                        }
            }
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
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

extension DashVC{
    func setuplayout(){
        Welcomelbl.anchorWith_TopLeftBottomRight_Padd(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        Mybalancelbl.anchorWith_XY_TopLeftBottomRight_Padd(x: nil, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: -100, left: 0, bottom: 0, right: 0))
        
        AddMoney.anchorWith_XY_TopLeftBottomRight_Padd(x: view.centerXAnchor, y: view.centerYAnchor, top: nil, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 20, bottom: 0, right: -20))
        
        SendMoney.anchorWith_TopLeftBottomRight_Padd(top: AddMoney.bottomAnchor, left: AddMoney.leadingAnchor, bottom: nil, right: AddMoney.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        AddUser.anchorWith_TopLeftBottomRight_Padd(top: SendMoney.bottomAnchor, left: AddMoney.leadingAnchor, bottom: nil, right: AddMoney.trailingAnchor, padd: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        LogoutBtn.anchorWith_TopLeftBottomRight_Padd(top: Welcomelbl.topAnchor, left: nil, bottom: nil, right: view.trailingAnchor, padd: .init(top: 0, left: 0, bottom: 0, right: -20))
        LogoutBtn.anchorWith_WidthHeight(width: nil, height: nil, constWidth: 30, constHeight: 30)
    }
}
