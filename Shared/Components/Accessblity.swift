//
//  Accessblity.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit

struct SIZES {
    static let BTN_Height : CGFloat = 40
    static let TxtHeight:CGFloat = 40
    static let HeaderHeight:CGFloat = 45
    static let FooterHeight:CGFloat = 80
    
    static let TxtFont:CGFloat = 14
}

struct COLORS {
    static let BtnBG = UIColor().hexToColor(hex: "#304FFE")
    static let BorderColor = UIColor().hexToColor(hex: "#304FFE")
    static let TxtBG = UIColor.white
    static let TextColor = UIColor.black
    static let BG = UIColor.white
    
}

struct IMAGES {
    static let Logo = UIImage(named:"Logo")
}

struct STR_UserDefault {
   static let Role = "role"
    static let Name = "name"
}
