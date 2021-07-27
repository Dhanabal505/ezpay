//
//  LoaderView.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import Foundation
import UIKit

class LoaderView:NSObject {
    
    lazy var blackView:UIView={
        let view = UIView()
        return view
    }()
    
    lazy var loaderView:UIView={
        let view=UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    lazy var activityLoader:UIActivityIndicatorView={
        let activity=UIActivityIndicatorView(style: .whiteLarge)
        activity.startAnimating()
        return activity
    }()
    
    func showLoader(){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            window.addSubview(blackView)
            window.addSubview(loaderView)
            window.addSubview(activityLoader)
            

            loaderView.anchorWith_XY_Padd(x: window.centerXAnchor, y: window.centerYAnchor)
            loaderView.anchorWith_WidthHeight(width: nil, height: nil, constWidth: 100, constHeight: 100)

            //activityLoader.anchorWith_XY_Padd(x: loaderView.centerXAnchor, y: loaderView.centerYAnchor)
//            activityLoader.anchorWith_WidthHeight(width: nil, height: nil, constWidth: 100, constHeight: 100)
            
            activityLoader.center=window.center
            
            blackView.frame=window.frame
            blackView.alpha=0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha=1
            
            }) { (completed) in
                
            }
            
        }
    }
    func hideLoader(){
        if UIApplication.shared.keyWindow != nil{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha=0
                self.loaderView.removeFromSuperview()
                self.activityLoader.removeFromSuperview()
                
            }) { (completed) in
                
            }
            
        }
    }
}


