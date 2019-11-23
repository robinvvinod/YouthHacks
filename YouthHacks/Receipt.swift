//
//  Receipt.swift
//  YouthHacks
//
//  Created by Eugene L. on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import Foundation

class Receipt: NSObject, Codable {
    
    struct LineItem: Codable {
        
        var itemGroup: UInt8
        var itemDescription: String
        var itemValue: Float
        var itemQuantity: UInt16
        
        init(itemGrp: UInt8, itemDesc: String, itemVal: Float, itemQty: UInt16) {
            
            itemGroup = itemGrp
            itemDescription = itemDesc
            itemValue = itemVal
            itemQuantity = itemQty
            
        }
        
    }
    
    var transactionMerchantID: UInt16
    var transactionNo: UInt32
    var transactionDate: Date
    var transactionItems: [LineItem]
    var transactionLoyalty: UInt16?
    var transactionMsg: String
    
    init(tMerchantID: UInt16, tNo: UInt32, tDate: Date, tItems: [LineItem], tLoyalty: UInt16?, tMsg: String) {
        
        transactionMerchantID = tMerchantID
        transactionNo = tNo
        transactionDate = tDate
        transactionItems = tItems
        transactionLoyalty = tLoyalty
        transactionMsg = tMsg
        
    }

}

struct ItemGroup {
    
    let Mapping = [
        1:"Product",
        2:"Discount",
        3:"Tax",
        4:"Miscellaneous"
    ]
    
}
