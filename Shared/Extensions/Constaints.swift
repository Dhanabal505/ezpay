//
//  Constaints.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit
import CoreImage

extension UIView{
    
    func anchorWith_XY_Padd(x:NSLayoutXAxisAnchor?,y:NSLayoutYAxisAnchor?,padd:UIEdgeInsets = .zero){
        
        if x != nil{
            centerXAnchor.constraint(equalTo: x!, constant: padd.left).isActive=true
        }
        if y != nil{
            centerYAnchor.constraint(equalTo: y!, constant: padd.top).isActive=true
        }
    }
    
    func anchorWith_XY_TopLeftBottomRight_Padd(x:NSLayoutXAxisAnchor?,y:NSLayoutYAxisAnchor?,top:NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,right:NSLayoutXAxisAnchor?,padd:UIEdgeInsets = .zero){
        
        if x != nil{
            centerXAnchor.constraint(equalTo: x!, constant: padd.left).isActive=true
        }
        if y != nil{
            centerYAnchor.constraint(equalTo: y!, constant: padd.top).isActive=true
        }
        
        if top != nil{
            topAnchor.constraint(equalTo: top!, constant: padd.top).isActive=true
        }
        if left != nil{
            leadingAnchor.constraint(equalTo: left!, constant: padd.left).isActive=true
        }
        if bottom != nil{
            bottomAnchor.constraint(equalTo: bottom!, constant: padd.bottom).isActive=true
        }
        if right != nil{
            trailingAnchor.constraint(equalTo: right!, constant: padd.right).isActive=true
        }
    }
    
    func anchorWith_TopLeftBottomRight_Padd(top:NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,right:NSLayoutXAxisAnchor?,padd:UIEdgeInsets = .zero){
        
        if top != nil{
            topAnchor.constraint(equalTo: top!, constant: padd.top).isActive=true
        }
        if left != nil{
            leadingAnchor.constraint(equalTo: left!, constant: padd.left).isActive=true
        }
        if bottom != nil{
            bottomAnchor.constraint(equalTo: bottom!, constant: padd.bottom).isActive=true
        }
        if right != nil{
            trailingAnchor.constraint(equalTo: right!, constant: padd.right).isActive=true
        }
        
    }
    
    func anchorWith_WidthHeight(width:NSLayoutDimension?,height:NSLayoutDimension?,constWidth:CGFloat?,constHeight:CGFloat?){
        
        if width != nil && constWidth != nil{
            widthAnchor.constraint(equalTo: width!, multiplier: constWidth!).isActive=true
        }
        else if constWidth != nil{
            widthAnchor.constraint(equalToConstant: constWidth!).isActive=true
        }
        
        if height != nil && constHeight != nil{
            heightAnchor.constraint(equalTo: height!, multiplier: constHeight!).isActive=true
        }
        else if constHeight != nil{
            heightAnchor.constraint(equalToConstant: constHeight!).isActive=true
        }
        
    }
    
    func anchorWith_Width(width:NSLayoutDimension?,const:CGFloat){
        if width != nil{
            widthAnchor.constraint(equalTo: width!, multiplier: const).isActive=true
        }
        else{
            widthAnchor.constraint(equalToConstant: const).isActive=true
        }
    }
    
    func anchorWith_Height(height:NSLayoutDimension?,const:CGFloat){
        if height != nil{
            heightAnchor.constraint(equalTo: height!, multiplier: const).isActive=true
        }
        else{
            heightAnchor.constraint(equalToConstant: const).isActive=true
        }
    }
    
    
    
}

