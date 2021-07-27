//
//  CustomTxtFlds.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import Foundation
import UIKit

class CustomHeaderTXT:UIView{
    
    lazy var lblHeader:UILabel={
        let lbl = UILabel()
        lbl.setCustomLBL(str: "", color: .black, align: .left, size: 14)
        return lbl
    }()
    
    lazy var txtField:UITextField={
        let txt = UITextField()
        txt.backgroundColor = .lightGray
        txt.textColor = .black
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    required init(header:String,placeholder:String,isPass:Bool?=false,isDrop:UIImage?=nil) {
        super.init(frame: .zero)
        
        lblHeader.text = header
        txtField.setPlaceholder(str: placeholder)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints=false
        txtField.borderStyle = .roundedRect
        txtField.layer.borderColor = COLORS.BtnBG.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 5
        
        self.addSubview(lblHeader)
        self.addSubview(txtField)
        
        
        lblHeader.anchorWith_TopLeftBottomRight_Padd(top: topAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor)
        
        txtField.anchorWith_TopLeftBottomRight_Padd(top: lblHeader.bottomAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor,padd: .init(top: 5, left: 0, bottom: 0, right: 0))
        txtField.anchorWith_Height(height: nil, const: SIZES.TxtHeight)
        
        self.anchorWith_Height(height: nil, const: 65)
        
    }
    
    @objc func handleTap(){
        print(txtField.text!)
        print("Call")
        if txtField.text?.count != 0 {
        guard let url = URL(string: "telprompt://\(txtField.text!)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            self.makeToast("Provide the Number to make a call")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
