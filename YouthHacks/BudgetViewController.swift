//
//  BudgetViewController.swift
//  YouthHacks
//
//  Created by Robin Vinod on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var monthlySpendView: UIView!
    @IBOutlet weak var budgetProgressBar: UIView!
    @IBOutlet weak var curSpendLabel: UILabel!
    @IBOutlet weak var maxSpendLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func rewardBtn(_ sender: Any) {
        print("clicked")
    }
    
    var curSpend : Float = 400.25
    var maxSpend : Float = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        
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
        budgetProgressBar.addGradientBackground(firstColor: .green, secondColor: .systemGreen, lr: true, width: Double(budgetProgressBar.frame.width) * Double(curSpend/maxSpend), height: Double(budgetProgressBar.frame.height))
        
    }
    
}

extension BudgetViewController:  UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        cell.addGradientBackground(firstColor: UIColor(red: 21/255, green: 87/255, blue: 191/255, alpha: 1.0), secondColor: UIColor(red: 75/255, green: 135/255, blue: 229/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
        
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

extension BudgetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
