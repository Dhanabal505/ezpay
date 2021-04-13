//
//  CustomImgs.swift
//  ezpay
//
//  Created by Albert Charles on 06/04/21.
//

import Foundation
import UIKit


class CustomIMG:UIImageView{
    
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        if image != nil{
            self.image = image
        }
        self.translatesAutoresizingMaskIntoConstraints=false
        self.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
