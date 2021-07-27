//
//  ViewController.swift
//  ezpay
//
//  Created by Albert Charles on 02/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            print(Auth.auth().currentUser?.uid)
            if Auth.auth().currentUser?.uid.count != 0 && Auth.auth().currentUser?.uid != nil{
                UserModel.ref = Database.database().reference()
                UserModel.ref.observe(.childAdded, with: { (snapshot) in
                    print(snapshot)
                    if snapshot.key != "User"{
                        if Auth.auth().currentUser!.uid == snapshot.key{
                            if let userDict = snapshot.value as? [String:Any] {
                                var Role = ""
                                for data in userDict{
                                    if data.key == "Role"{
                                     Role = data.value as! String
                                    }
                                    if Role == "Admin" || Role == "Donar"{
                                        let vc = DashVC()
                                        vc.isSignin = false
                                        NavigationModel.redirectVC(to: vc)
                                        return
                                    }else if Role == "Merchant"{
                                        let vc = MerchantDashVC()
                                        NavigationModel.redirectVC(to: vc)
                                        return
                                    }
                                }
                            }
                        }
                     }
                })
            }else{
            let vc = MainVC()
            NavigationModel.redirectVC(to: vc)
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
