//
//  PlanetsCollectionViewCell.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/11/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import UIKit
import SwiftyJSON
import SpriteKit
import SceneKit

class PlanetsCollectionViewCell: UICollectionViewCell {
    
    var body: JSON! {
        didSet{
            circlePath = UIBezierPath(arcCenter: CGPoint(
                x: self.frame.width / 2, y: self.frame.height / 2),
                radius: CGFloat(body["diameter"].floatValue / 2 * 8),
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
            )
    
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = Info.bodiesColors[body["name"].stringValue]!.cgColor
        }
    }
    
    var index:Int!
    
    var circlePath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
