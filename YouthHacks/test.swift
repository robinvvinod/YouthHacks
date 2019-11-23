//
//  test.swift
//  YouthHacks
//
//  Created by Eugene L. on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

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
