//
//  Extensions.swift
//  SolarSystem
//
//  Created by Robert Kim on 7/17/17.
//  Copyright © 2017 Octopus. All rights reserved.
//

import UIKit
import SceneKit


public extension SCNAction {
    
    class func rotateAround(center: SCNVector3, radius: CGFloat, animationDuration: Double) -> SCNAction {
        
        var actions = [SCNAction]()
        
        let startAngle = Int(arc4random_uniform(359))
        
        for i in startAngle...(360 + startAngle)  {
        
            let x = sin(i.cgFloat.rad) * radius - CGFloat(center.x)
            let z = cos(i.cgFloat.rad) * radius + CGFloat(center.z)
            
            let position = SCNVector3(x, CGFloat(center.y), z)
            
            let moveAction = SCNAction.move(to: position, duration: animationDuration / 360)
            
            actions.append(moveAction)
        }
        
        return SCNAction.repeatForever(SCNAction.sequence(actions))
       
    }
    
//    class func rotateRandomAngle(center: SCNVector3, radius: CGFloat) -> SCNAction{
//        
//        let randomAngle = Int(arc4random_uniform(359))
//        
//        let randomX = sin(randomAngle.cgFloat.rad) * radius - CGFloat(center.x)
//        let randomZ = cos(randomAngle.cgFloat.rad) * radius + CGFloat(center.z)
//        
//        let position = SCNVector3(randomX, CGFloat(center.y), randomZ)
//        let moveAction = SCNAction.move(to: position, duration: 0.001)
//        
//        return moveAction
//        
//    }
    
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

extension Int {
    public var cgFloat: CGFloat {
        
        get {
            return CGFloat(self)
        }
        
        set {
            
        }
    }
}










