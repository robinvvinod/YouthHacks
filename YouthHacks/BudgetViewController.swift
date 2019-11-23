//
//  BudgetViewController.swift
//  YouthHacks
//
//  Created by Robin Vinod on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {
    
    @IBOutlet weak var monthlySpendView: UIView!
    @IBOutlet weak var budgetProgressBar: UIView!
    @IBOutlet weak var curSpendLabel: UILabel!
    @IBOutlet weak var maxSpendLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthlySpendView.layer.cornerRadius = 10
        monthlySpendView.clipsToBounds = true
        monthlySpendView.dropShadow(radius: 10)
        
        budgetProgressBar.layer.cornerRadius = 3
        budgetProgressBar.clipsToBounds = true
        var curSpend : Float = 400.25
        var maxSpend : Float = 1000
        budgetProgressBar.addGradientBackground(firstColor: .green, secondColor: .systemGreen, lr: true, width: Double(budgetProgressBar.frame.width) * Double(curSpend/maxSpend), height: Double(budgetProgressBar.frame.height))
        
    }
}
