//
//  ReceiptViewController.swift
//  YouthHacks
//
//  Created by Eugene L. on 24/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ReceiptList: [Receipt] = []
    let reuseIdentifier = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReceiptList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

class ReceiptViewCell: UITableViewCell {
    
}
