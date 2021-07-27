//
//  CustomBtns.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit

class CustomFormBTNs:UIButton{
    
    required init(title:String,bgColor:UIColor,textColor:UIColor,radii:CGFloat?=5,isBordered:Bool?=true) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if title != ""{
            self.setTitle(title, for: .normal)
        }
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
       // self.titleLabel?.font = FONTS.Quicksand_SemiBold(size: 14).Identifier
       // self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if radii != nil{
            self.layer.cornerRadius = radii!
        }
        else{
            self.layer.cornerRadius = 5
        }
        
        if let isBorder = isBordered{
            if isBorder{
                self.layer.borderColor = COLORS.BorderColor.cgColor
                self.layer.borderWidth = 1
            }
        }
        
        self.anchorWith_Height(height: nil, const: SIZES.BTN_Height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomImgBTN:UIButton{
    
    required init(img:UIImage) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints=false
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomIMAGEBTN:UIButton{
    
    required init(img:UIImage) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints=false
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

