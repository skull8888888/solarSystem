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
        
        for i in 0...360 {
            
            let x = sin(i.cgFloat.rad) * radius - CGFloat(center.x)
            let z = cos(i.cgFloat.rad) * radius + CGFloat(center.z)
            
            let moveAction = SCNAction.move(to: SCNVector3(x, CGFloat(center.y), z), duration: animationDuration / 360)
            
            actions.append(moveAction)
        }
        
        return SCNAction.sequence(actions)
       
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

extension Int {
    public var cgFloat: CGFloat {
        
        get {
            return CGFloat(self)
        }
        
        set {
            
        }
    }
}










