//
//  DataModel.swift
//  ezpay
//
//  Created by Albert Charles on 08/04/21.
//

import Foundation
import UIKit
import FirebaseDatabase
class Donar: Codable{
    var mail:String
    var balance:Double
    var DonarId:String
}
class Merchant: Codable{
    var mail:String
}
class Customer: Codable{
    var name:String?
    var balance:Double
    var TagId:String
}

class UserModel{
    static var UserData : Donar?
    static var CustomerData = [Customer]()
    static var ref : DatabaseReference!
    static var MerchantData : Merchant?
    static var PCustomer :Customer?
    
}
