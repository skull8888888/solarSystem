//
//  ViewController+Planets.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/12/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import UIKit
import SwiftyJSON
import SceneKit

extension ViewController {
    func setPlanets(){
        
        let sunSphere = SCNSphere(radius: 0.025)
        sunSphere.firstMaterial?.diffuse.contents = UIImage(named:"art.scnassets/SunTexture.jpg")
        sunSphere.firstMaterial?.lightingModel = .constant
        
        sunNode = SCNNode()
        sunNode.geometry = sunSphere
        sunNode.position = SCNVector3(0, 0, 0)
        sunNode.rotateAroundAxis(angle: 0.0, duration: 40)
        
        let light = SCNLight()
        let lightNode = SCNNode()
        lightNode.name = "Light"
        lightNode.light = light
        light.type = .omni
        light.castsShadow = true
        
        let ambientLight = SCNLight()
        let lightNode1 = SCNNode()
        lightNode1.name = "Light"
        lightNode1.light = ambientLight
        ambientLight.type = .ambient
        ambientLight.intensity = 70
        ambientLight.castsShadow = false
        
        
        sunNode.name = "Sun"
        sunNode.castsShadow = false
    
        wrapperNode = SCNNode()
        wrapperNode.position = SCNVector3(0, -0.25, -1)
        wrapperNode.addChildNode(sunNode)
        wrapperNode.addChildNode(lightNode)
        wrapperNode.addChildNode(lightNode1)
        
        for body in bodies.arrayValue {
            let bodyNode = Planet(body: body, bodyMulti: bodyMulti, distanceMulti: distanceMulti)
            drawOrbit(E: body["E"].float! , SMA: body["distance"].float! * distanceMulti)
            wrapperNode.addChildNode(bodyNode)
        }
        
        scene.rootNode.addChildNode(wrapperNode)
    }
    
    func drawOrbit(E: Float, SMA: Float){
        
        var indices = [Int32]()
        var vertices = [SCNVector3]()
        
        for i in 0...360 {
            
            let x = SMA * (cos(i.float.rad) - E)
            let z = SMA * sqrt(1 - E * E) * sin(i.float.rad)
            
            if i != 360 {
                indices.append(Int32(i))
                indices.append(Int32(i + 1))
            } else {
                indices.append(360)
                indices.append(Int32(0))
            }
            vertices.append(SCNVector3(x,0,z))
            
        }
        
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let shape = SCNGeometry(sources: [source], elements: [element])
        
        shape.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let orbitNode = SCNNode(geometry: shape)
        orbitNode.name = "orbit"
        wrapperNode.addChildNode(orbitNode)
    }
    
}
