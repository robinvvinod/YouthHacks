//
//  BudgetViewController.swift
//  YouthHacks
//
//  Created by Robin Vinod on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit
import SwiftChart

class BudgetViewController: UIViewController {
    
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
    
    @IBAction func nfcBtn(_ sender: Any) {
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
}

class collectionViewCell: UICollectionViewCell {
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsNameLabel: UILabel!
    @IBAction func merchantBtn(_ sender: Any) {
        print("clicked")
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
            cell.addGradientBackground(firstColor: UIColor(red: 21/255, green: 87/255, blue: 191/255, alpha: 1.0), secondColor: UIColor(red: 75/255, green: 135/255, blue: 229/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
            cell.merchantName.text = "Fairprice"
            cell.pointsLabel.text = "3,141"
            cell.pointsNameLabel.text = "LinkPoints"
        }
        else if indexPath.row == 1{
            cell.addGradientBackground(firstColor: UIColor(red: 39/255, green: 145/255, blue: 122/255, alpha: 1.0), secondColor: UIColor(red: 42/255, green: 156/255, blue: 99/255, alpha: 1.0), lr: true, width: Double(cell.frame.width), height: Double(cell.frame.height))
            cell.merchantName.text = "Giant"
            cell.pointsLabel.text = "2,459"
            cell.pointsNameLabel.text = "Points"
        }
        else {
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

extension BudgetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
