//
//  Extensions.swift
//  YouthHacks
//
//  Created by Robin Vinod on 23/11/19.
//  Copyright © 2019 robinvvinod. All rights reserved.
//

import UIKit

extension UIView {

    func dropShadow(radius: Int) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

    }
    
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor, lr: Bool, width: Double, height: Double){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        if lr {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
