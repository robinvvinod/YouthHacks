//
//  NFCTestViewController.swift
//  YouthHacks
//
//  Created by Eugene L. on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit
import CoreNFC

class NFCTestViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    var session: NFCNDEFReaderSession?
    var message = NFCNDEFMessage(records: [])
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a
            // successful read during a single-tag read session, or because the
            // user canceled a multiple-tag read session from the UI or
            // programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

        // To read new tags, a new session instance is required.
        self.session = nil
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                case .readWrite:
                    tag.writeNDEF(self.message, completionHandler: { (error: Error?) in
                        if nil != error {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                        }
                        session.invalidate()
                    })
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            })
        })
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            // Process detected NFCNDEFMessage objects.
        }
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session.alertMessage = "Hold your iPhone near the item to learn more about it."
        session.begin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let merchant = Receipt.Merchant(mName: "Popular Book Company", mAddr: "Ngee Ann Polytechnic", mPhoneNo: 12345678, mAltContacts: nil, mRegulatory: ["GST REG MR-8500027-X"])
        let item1 = Receipt.LineItem(itemGrp: "Purchase", itemDesc: "R. PEARL STRAWBERRY", itemVal: 2.15, itemQty: 2)
        let item3 = Receipt.LineItem(itemGrp: "Purchase", itemDesc: "PB Exam Pad A4 (1x5)", itemVal: 10.9, itemQty: 1)
        let item4 = Receipt.LineItem(itemGrp: "Discount", itemDesc: "", itemVal: 2, itemQty: 1)
        let itemList = [item1, item2, item3, item4]

        let r = Receipt(tNo: 1, tDate: Date(), tMerchant: merchant, tItems: itemList, tLoyalty: 0, tMsg: "")

        let encoder = JSONEncoder()

        let data = try! encoder.encode(r)

        let payload = NFCNDEFPayload(format: .nfcExternal, type: .init(), identifier: .init(), payload: data)

        message = NFCNDEFMessage(records: [payload])
        print(message.length)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
