//
//  ViewController.swift
//  ezpay
//
//  Created by Albert Charles on 02/04/21.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            let vc = MainVC()
            NavigationModel.redirectVC(to: vc)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
