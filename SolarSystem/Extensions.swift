//
//  Extensions.swift
//  SolarSystem
//
//  Created by Robert Kim on 7/17/17.
//  Copyright © 2017 Octopus. All rights reserved.
//

import UIKit
import SceneKit
import SwiftyJSON

public extension SCNNode {
    
    func rotateAroundAxis(angle: Float, duration: Double){
        
        let animation = CAKeyframeAnimation(keyPath: "pivot")
        
        var values = [SCNMatrix4]()
        
        for I in 0...360 {
            
            let i = I * -1
            
            let inclineMatrix = SCNMatrix4(
                m11: cos(angle.rad), m12: -sin(angle.rad), m13: 0, m14: 0,
                m21: sin(angle.rad), m22: cos(angle.rad), m23: 0, m24: 0,
                m31: 0, m32: 0, m33: self.scale.z , m34: 0,
                m41: 0, m42: 0, m43: 0, m44: 1
            )
            
            let rotateMatrix = SCNMatrix4(
                m11: cos(Float(i).rad), m12: 0, m13: sin(Float(i).rad), m14: 0,
                m21: 0, m22: 1, m23: 0, m24: 0,
                m31: -sin(Float(i).rad), m32: 0, m33: cos(Float(i).rad), m34: 0,
                m41: 0, m42: 0, m43: 0, m44: 1
            )
            
            let M = SCNMatrix4Mult(inclineMatrix, rotateMatrix)
            
            values.append(M)
        }
        
        animation.values = values
        animation.duration = duration
        animation.repeatCount = .infinity
        
        self.addAnimation(animation, forKey: nil)
    }
    
    
    func orbit(E: Float, SMA: Float, period: Double){
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        var values = [SCNVector3]()
        
        let startAngle = Int(arc4random_uniform(359))
        
        for i in startAngle...(360 + startAngle)  {
            let x = SMA * (cos(i.float.rad) - E)
            let z = SMA * sqrt(1 - E * E) * sin(i.float.rad)
            values.append(SCNVector3(x, 0, z))
        }
        
        animation.values = values
        animation.duration = period
        animation.repeatCount = .infinity
        
        self.addAnimation(animation, forKey: nil)
    }
    
    func orbitAround(E: Float, SMA: Float, period: Double) {
        
        var actions = [SCNAction]()
        
        let startAngle = Int(arc4random_uniform(359))
        
        for i in startAngle...(360 + startAngle)  {
            
            let x = SMA * (cos(i.float.rad) - E)
            let z = SMA * sqrt(1 - E * E) * sin(i.float.rad)
        
            let moveAction = SCNAction.move(to: SCNVector3(x, 0, z), duration: period / 360)
            
            actions.append(moveAction)
        }
        
        self.runAction(SCNAction.repeatForever(SCNAction.sequence(actions)))
        
    }
    
}

extension SCNVector3 {
    func length() -> Float{
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    }
    
    static func angleBetween(_ V1: SCNVector3, _ V2: SCNVector3) -> Float{
        
        let dotProduct = V1.x * V2.x + V1.y * V2.y + V1.z * V2.z
        let multi = V1.length() * V2.length()
        
        return acos(dotProduct / multi)
    
    }
    
    static func orientation(_ A: SCNVector3, _ B: SCNVector3) -> Float{
        let det = A.x * B.z - B.x * A.z
        return det > 0 ? -1: 1
    }
    
    static func vector(_ A: SCNVector3, _ B: SCNVector3) -> SCNVector3 {
        return SCNVector3(B.x - A.x,B.y - A.y,B.z - A.z)
    }
}

extension UIView {
    
    func blur(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func toggle(){
        self.isHidden ? show() : hide()
    }
    
    func hide(){
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.layer.opacity = 0.0
        }, completion: { Void in
            self.isHidden = true
        })
        
    }
    
    func show(){
        self.isUserInteractionEnabled = true
        self.isHidden = false
        self.layer.opacity = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    func drawCircle(radius: CGFloat, color: UIColor) {
        
        let center = self.center
        
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath.circle(radius: radius, center: center)
        layer.fillColor = color.cgColor
        
        self.layer.addSublayer(layer)
    }
    
//    func drawLine(color: UIColor){
//        
//        let layer = CAShapeLayer()
//        
//        layer.path = UIBezierPath.line(A: CGPoint(x: 2, y: center.y), B: CGPoint(x:self.bounds.width - 2, y: center.y))
//        layer.fillColor = UIColor.clear.cgColor
//        layer.strokeColor = color.cgColor
//        
//        self.layer.addSublayer(layer)
//    }
}

extension UIBezierPath {
    
    class func circle(radius: CGFloat, center: CGPoint) -> CGPath{
        
        return UIBezierPath(arcCenter: center,
                                  radius: radius,
                                  startAngle: 0,
                                  endAngle: CGFloat.pi * 2,
                                  clockwise: true).cgPath
    }
    
    class func line(A: CGPoint, B: CGPoint) -> CGPath{
        let path = UIBezierPath()
        
        let H: CGFloat = 2
        
        path.move(to: CGPoint(x: A.x, y: A.y + H))
        path.addLine(to: CGPoint(x: A.x, y: A.y - H))
        path.addLine(to: A)
        path.addLine(to: B)
        path.addLine(to: CGPoint(x: B.x, y: B.y + H))
        path.addLine(to: CGPoint(x: B.x, y: B.y - H))
        
        path.lineWidth = 1
        
        return path.cgPath
    }
  
}

extension CGFloat {
    
    public var rad: CGFloat {
        
        get {
            return self / 180 * CGFloat.pi
        }
        
        set {
            
        }
        
    }
    
}

extension Float {
    
    public var rad: Float {
        
        get {
            return self / 180 * Float.pi
        }
        
        set {
            
        }
        
    }
    
}

extension Int {
    public var cgFloat: CGFloat {
        
        get {
            return CGFloat(self)
        }
        
        set {
            
        }
    }
    
    public var float: Float {
        
        get {
            return Float(self)
        }
        
        set {
            
        }
    }
}
