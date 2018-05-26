
//
//  Planet.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/20/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import Foundation
import SceneKit
import SwiftyJSON

class Planet: SCNNode {
    
    init(body: JSON, bodyMulti: Float, distanceMulti: Float) {
        super.init()
        
        let bodySphere = SCNSphere(radius: CGFloat(bodyMulti * body["diameter"].float! / 2))
        
        bodySphere.firstMaterial?.diffuse.contents = UIImage(named: body["materials"]["diffuse"].stringValue)
        
        if body["materials"]["emission"].exists() {
             bodySphere.firstMaterial?.emission.contents = UIImage(named: body["materials"]["emission"].stringValue)
        }

        if body["materials"]["displacement"].exists() {
            bodySphere.firstMaterial?.displacement.contents = UIImage(named: body["materials"]["displacement"].stringValue)
        }

        bodySphere.segmentCount = 64
        
        self.name = body["name"].string!
        self.geometry = bodySphere
        
        for moon in body["moons"].arrayValue {
            
            let moonSphere = SCNSphere(radius: CGFloat(moon["diameter"].floatValue / 2 * bodyMulti))
            moonSphere.firstMaterial?.diffuse.contents = UIImage(named: moon["material"].stringValue)
            let moonNode = SCNNode()
            moonNode.geometry = moonSphere
            moonNode.orbit(E: 0, SMA: moon["distance"].floatValue, period: moon["period"].doubleValue)
            self.addChildNode(moonNode)
        }

        
        if body["ring"].exists() {
            let ring = body["ring"]
            let ringShape = SCNTube(innerRadius: CGFloat(bodyMulti * ring["inner"].float!), outerRadius: CGFloat(bodyMulti * ring["outer"].float!), height: CGFloat(ring["height"].float!))
            ringShape.firstMaterial?.diffuse.contents = UIImage(named: ring["image"].stringValue)
            
            let ringNode = SCNNode()
            ringNode.geometry = ringShape
            
            self.addChildNode(ringNode)
        }
        
        self.rotateAroundAxis(angle: body["angle"].float!, duration: body["rotationPeriod"].double! * 10)
        self.orbitAround(E: body["E"].float! , SMA: body["distance"].float! * distanceMulti, period: body["period"].double!  * 10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


