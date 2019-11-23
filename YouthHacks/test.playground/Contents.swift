import Foundation
import UIKit
import CoreNFC

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

import Foundation

let merchant = Receipt.Merchant(mName: "Popular Book Company", mAddr: "Ngee Ann Polytechnic", mPhoneNo: 12345678, mAltContacts: nil, mRegulatory: ["GST REG MR-8500027-X"])
let item1 = Receipt.LineItem(itemGrp: "Purchase", itemDesc: "R. PEARL STRAWBERRY", itemVal: 2.15, itemQty: 1)
let item2 = Receipt.LineItem(itemGrp: "Purchase", itemDesc: "R. PEARL STRAWBERRY", itemVal: 2.15, itemQty: 1)
let item3 = Receipt.LineItem(itemGrp: "Purchase", itemDesc: "PB Exam Pad A4 (1x5)", itemVal: 10.9, itemQty: 1)
let item4 = Receipt.LineItem(itemGrp: "Discount", itemDesc: "PB Exam Pad A4 (1x5)", itemVal: 2, itemQty: 1)
let itemList = [item1, item2, item3, item4]

let r = Receipt(tNo: 1, tDate: Date(), tMerchant: merchant, tItems: itemList, tLoyalty: 0, tMsg: "Sign up as a member to enjoy 10% off at Popular and UrbanWrite. T&C apply.")

let encoder = JSONEncoder()

let data = try! encoder.encode(r)

let payload = NFCNDEFPayload(format: .nfcExternal, type: .init(), identifier: .init(), payload: data)

let message = NFCNDEFMessage(records: [payload])
