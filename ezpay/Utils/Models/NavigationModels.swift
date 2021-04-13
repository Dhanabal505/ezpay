//
//  NavigationModels.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit
import SafariServices

class NavigationModel{
    
    static var vcViewModel=UIViewController()
    static var navViewModel=[UIViewController]()
    
    static var SelectedTAB:Int?
    
    public static func setNavController(vc:UIViewController){
        if navViewModel.last != vc{
            self.navViewModel.append(vc)
        }
    }
    public static func removeAllNavController(){
        self.navViewModel.removeAll()
    }
    
    
    public static func redirectVC(to:UIViewController){
        let vc = vcViewModel
        vc.navigationController?.pushViewController(to, animated: true)
    }
    
    public static func redirectPerticularVC(to:AnyClass){
        let vc = vcViewModel
        for controller in vc.navigationController!.viewControllers as Array{

            if controller.isKind(of: to){
                vc.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    public static func popViewController(){
        let vc = vcViewModel
        vc.navigationController?.popViewController(animated: true)
    }
    
    public static func presentVC(to:UIViewController){
        let vc = vcViewModel
        vc.present(to, animated: true, completion: nil)
    }
    
    public static func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        let vc = vcViewModel
        vc.addChild(viewController)
        // Add Child View as Subview
        vc.view.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = vc.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: vc.self)
    }
    
    public func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    
    
    public static func showLogoutAlert(){
        let alert = UIAlertController(title: "Logout!", message: "Are you really want to logout?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (actions) in
           // redirectPerticularVC(to: LoginVC.self)
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        let vc = vcViewModel
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    public static func setSelectedTAB(index:Int?){
        SelectedTAB = index
    }

}

class LOCALSTORAGE{
    static func setLocalData(key:String,data:Any?){
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getLocalData(key:String)->Any?{
        if let data = UserDefaults.standard.value(forKey: key){
            return data
        }
        return nil
    }
    
    static func removeAllData(){
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}
