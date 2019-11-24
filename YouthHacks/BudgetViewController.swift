//
//  BudgetViewController.swift
//  YouthHacks
//
//  Created by Robin Vinod on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit
import SwiftChart
import CoreNFC
import Firebase

var datePush = ""
var idPush = ""
var receipts = [Array<Any>]()

class BudgetViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var todaySpendLabel: UILabel!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var monthlySpendView: UIView!
    @IBOutlet weak var budgetProgressBar: UIView!
    @IBOutlet weak var curSpendLabel: UILabel!
    @IBOutlet weak var maxSpendLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var chartView: UIView!
    
    let ref = Database.database().reference()
        
    @IBAction func nfcBtn(_ sender: Any) {
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
        session.alertMessage = "Looking for receipt..."
        session.begin()
    }
    
    var curSpend : Float = 0
    var maxSpend : Float = 0
    var rewardsDict = ["Fairprice":0, "Giant":0]
    var merchants = [23422:"Fairprice", 23423:"Giant"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pushData") {
            let vc = segue.destination as! ReceiptViewController
            vc.date = datePush
            vc.id = idPush
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("merchantIDs").observeSingleEvent(of: .value) { snapshot in
            let array:NSArray = snapshot.children.allObjects as NSArray
            for child in array {
                let snap = child as! DataSnapshot
                let valueDict = snap.value as? NSDictionary
                self.rewardsDict.updateValue(valueDict?["loyaltyPoints"] as! Int, forKey: valueDict?["name"] as! String)
            }
            self.collectionView.reloadData()
        }
        
        ref.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            self.curSpend = value?["curSpend"] as! Float
            self.maxSpend = value?["maxSpend"] as! Float
            self.curSpendLabel.text = "$" + String(self.curSpend)
            self.maxSpendLabel.text = "$" + String(self.maxSpend)
            self.curSpendLabel.setNeedsDisplay()
            self.maxSpendLabel.setNeedsDisplay()
            self.budgetProgressBar.addGradientBackground(firstColor: .green, secondColor: .systemGreen, lr: true, width: Double(self.budgetProgressBar.frame.width) * Double(self.curSpend/self.maxSpend), height: Double(self.budgetProgressBar.frame.height))
        }
        
        ref.child("Receipts").observeSingleEvent(of: .value) { snapshot in
            let array:NSArray = snapshot.children.allObjects as NSArray
            for child in array {
                let snap = child as! DataSnapshot
                let subArray:NSArray = snap.children.allObjects as NSArray
                for child in subArray {
                    let snap = child as! DataSnapshot
                    let valueDict = snap.value as? NSDictionary
                    
                    let components = NSURL(fileURLWithPath: snap.ref.url).pathComponents!.dropFirst()
                    
                    receipts.append([valueDict?["merchantID"] as! Int, Float((valueDict?["TotalPrice"] as! NSNumber).stringValue)!, valueDict?["Time"] as! String, components[4], components[5]])
                }
                self.tableView.reloadData()
            }
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableViewContainer.layer.cornerRadius = 10
        tableViewContainer.clipsToBounds = true
        tableViewContainer.dropShadow(radius: 10)
        
        collectionViewContainer.layer.cornerRadius = 10
        collectionViewContainer.clipsToBounds = true
        collectionViewContainer.dropShadow(radius: 10)
        
        monthlySpendView.layer.cornerRadius = 10
        monthlySpendView.clipsToBounds = true
        monthlySpendView.dropShadow(radius: 10)
        
        budgetProgressBar.layer.cornerRadius = 3
        budgetProgressBar.clipsToBounds = true
        
        chartView.layer.cornerRadius = 10
        chartView.clipsToBounds = true
        chartView.dropShadow(radius: 10)
        
        let data = [
            (x: 15, y: 20.0),
            (x: 16, y: 21.0),
            (x: 17, y: 27.0),
            (x: 18, y: 32.0),
            (x: 19, y: 23.0),
            (x: 20, y: 15.0),
            (x: 21, y: 23.0),
            (x: 22, y: 19.0),
            (x: 23, y: 24.0),
            (x: 24, y: 22.0),
            (x: 25, y: 26.0)
        ]
        
        let series = ChartSeries(data: data)
        series.area = true

        // Use `xLabels` to add more labels, even if empty
        var xLabels = [Double]()
        for i in 15...25 {
            xLabels.append(Double(i))
        }
        
        var yLabels = [Double]()
        for i in 0...32  where i%10 == 0 {
            yLabels.append(Double(i))
        }
        
        chart.yLabels = yLabels
        chart.xLabels = xLabels
        chart.minY = 0
        
        series.colors = (
          above: ChartColors.orangeColor(),
          below: ChartColors.greenColor(),
          zeroLevel: 25
        )

        // Format the labels with a unit
        chart.xLabelsFormatter = {String(Int(round($1)))}
        chart.yLabelsFormatter = {"$" + String(Int(round($1)))}

        chart.add(series)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
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
                    session.alertMessage = "Reading Reciept..."
                    tag.readNDEF(completionHandler: { (message: NFCNDEFMessage?, error: Error?) in
                        var statusMessage: String
                        if nil != error || nil == message {
                            statusMessage = "Fail to read NDEF from tag"
                        } else {
                            statusMessage = "Found 1 NDEF message"
                            DispatchQueue.main.async {
                                // Process detected NFCNDEFMessage objects.
                                if message != nil {
                                    let records = message!.records
                                    let receiptData = records.first?.payload ?? Data()
                                    
                                    print(receiptData)
                                    
                                    let decoder = JSONDecoder()
                                    if let decodedReceipt = try? decoder.decode(Receipt.self, from: receiptData) {
                                        print(decodedReceipt)
                                    }
                                    
                                    self.ref.child("Receipts").child("2").child("Time").setValue("1.10pm")
                                //self.ref.child("Receipts").child("2").setValuesForKeys(["Items" : ["R. PEARL STRAWBERRY": 2.15, "PB Exam Pad A4 (1x5)": 10.9],"TotalPrice" : Double(13.05),"loyaltyPoints" : 24,"merchantID" : 23422])
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                        session.alertMessage = statusMessage
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
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
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
    }
}

class collectionViewCell: UICollectionViewCell {
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsNameLabel: UILabel!
    @IBAction func merchantBtn(_ sender: Any) {
    }
    
}

extension BudgetViewController:  UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! collectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        if indexPath.row == 0 {
            if cell.layer.sublayers?.count ?? 0 > 1 {
                cell.layer.sublayers?.remove(at: 0)
            }
            cell.addGradientBackground(firstColor: UIColor(red: 21/255, green: 87/255, blue: 191/255, alpha: 1.0), secondColor: UIColor(red: 75/255, green: 135/255, blue: 229/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
            cell.merchantName.text = "Fairprice"
            cell.pointsLabel.text = String(rewardsDict["Fairprice"]!)
            cell.pointsNameLabel.text = "LinkPoints"
        }
            
        if indexPath.row == 1 {
            if cell.layer.sublayers?.count ?? 0 > 1 {
                cell.layer.sublayers?.remove(at: 0)
            }
            cell.addGradientBackground(firstColor: UIColor(red: 39/255, green: 145/255, blue: 122/255, alpha: 1.0), secondColor: UIColor(red: 42/255, green: 156/255, blue: 99/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
            cell.merchantName.text = "Giant"
            cell.pointsLabel.text = String(rewardsDict["Giant"]!)
            cell.pointsNameLabel.text = "Points"
        }
        
        if indexPath.row == 2 {
            if cell.layer.sublayers?.count ?? 0 > 1 {
                cell.layer.sublayers?.remove(at: 0)
            }
            cell.addGradientBackground(firstColor: UIColor(red: 255/255, green: 95/255, blue: 0/255, alpha: 1.0), secondColor: UIColor(red: 254/255, green: 229/255, blue: 106/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
            cell.merchantName.text = "Lazada"
            cell.pointsLabel.text = "42"
            cell.pointsNameLabel.text = "Hearts"
        }
        
        return cell
    }
}

extension BudgetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension BudgetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

class tableViewCell: UITableViewCell {
    @IBOutlet weak var receiptNameBtn: UIButton!
    @IBOutlet weak var priceBtn: UIButton!
    
}

extension BudgetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = receipts[indexPath.row]
        datePush = selected[3] as! String
        idPush = selected[4] as! String
        performSegue(withIdentifier: "pushData", sender: (Any).self)
    }
}

extension BudgetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableViewCell
        
        //cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let nameTime = merchants[(receipts[indexPath.row][0] as! Int)]! + " - " + String((receipts[indexPath.row][2] as! String))
        let price = "$" + String(receipts[indexPath.row][1] as! Float)
        cell.receiptNameBtn.setTitle(nameTime, for: .normal)
        cell.priceBtn.setTitle(price, for: .normal)
        
        return cell
    }
}
