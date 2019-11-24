//
//  ReceiptViewController.swift
//  YouthHacks
//
//  Created by Eugene L. on 24/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit
import Firebase

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference()
    var date = "24-11-2019"
    var id = "1"
    
    var itemNames = [String]()
    var itemPrices = [NSNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    ref.child("Receipts").child(date).child(id).child("Items").observeSingleEvent(of: .value) { snapshot in
                for case let rest as DataSnapshot in snapshot.children {
                    self.itemNames.append(rest.key)
                    self.itemPrices.append(rest.value as! NSNumber)
                }
                self.tableView.reloadData()
            }
        
        self.tableView.dataSource = self
        
    }
        
}
    
class receiptTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var priceLabel: UIButton!
}

extension ReceiptViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell", for: indexPath) as! receiptTableViewCell
        
        cell.nameLabel.setTitle(itemNames[indexPath.row], for: .normal)
        cell.priceLabel.setTitle("$" + itemPrices[indexPath.row].stringValue, for: .normal)
        return cell
        
    }
    
    
}
