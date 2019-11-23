//
//  Receipt.swift
//  YouthHacks
//
//  Created by Eugene L. on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import Foundation

class Receipt: NSObject, Codable {
    
    struct Merchant: Codable {
        
        var merchantName: String
        var merchantAddr: String
        var merchantPhoneNo: Int
        var merchantAltContacts: [String]?
        var merchantRegulatory: [String]?
        
        init(mName: String, mAddr: String, mPhoneNo: Int, mAltContacts: [String]?,
            mRegulatory: [String]?) {
            
            merchantName = mName
            merchantAddr = mAddr
            merchantPhoneNo = mPhoneNo
            merchantAltContacts = mAltContacts
            merchantRegulatory = mRegulatory
            
        }
        
    }
    
    struct LineItem: Codable {
        
        var itemGroup: String
        var itemDescription: String
        var itemValue: Double
        var itemQuantity: Int
        
        init(itemGrp: String, itemDesc: String, itemVal: Double, itemQty: Int) {
            
            itemGroup = itemGrp
            itemDescription = itemDesc
            itemValue = itemVal
            itemQuantity = itemQty
            
        }
        
    }
    
    var transactionNo: Int
    var transactionDate: Date
    var transactionMerchant: Merchant
    var transactionItems: [LineItem]
    var transactionLoyalty: Int?
    var transactionMsg: String?
    
    init(tNo: Int, tDate: Date, tMerchant: Merchant, tItems: [LineItem], tLoyalty: Int?, tMsg: String?) {
        
        transactionNo = tNo
        transactionDate = tDate
        transactionMerchant = tMerchant
        transactionItems = tItems
        transactionLoyalty = tLoyalty
        transactionMsg = tMsg
        
    }

}
