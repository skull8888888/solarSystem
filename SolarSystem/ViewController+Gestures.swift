//
//  ViewController+Gestures.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/12/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import UIKit
import SceneKit
import SwiftyJSON
import ARKit

extension ViewController {
    
    @objc func handlePinch(gesture:UIPinchGestureRecognizer){
        
        print("pinch")
        
        switch gesture.state {
        case .changed:
            
            var scale = self.scale * Float(gesture.scale)
            
            if scale > self.maxScale {
                scale = self.maxScale
            } else if scale < self.minScale {
                scale =  self.minScale
            }
            
            wrapperNode.scale = SCNVector3(scale,scale,scale)
        case .ended:
            
            let scale = self.scale * Float(gesture.scale)
            
            if scale > self.maxScale {
                self.scale = self.maxScale
            } else if scale < self.minScale {
                self.scale =  self.minScale
            } else {
                self.scale = scale
            }
        default:
            break
        }
    }
    
    @objc func handleTap(gesture:UIPinchGestureRecognizer){
        
        if clearView == false{
            infoButton.hide()
            resetButton.hide()
            infoContainerView.hide()
            planetsContainerView.hide()
        } else {
            
            if selectedPlanet == true {
                infoButton.show()
                resetButton.show()
                planetsContainerView.show()
                
                if showInfo {
                    infoContainerView.show()
                }
                
            } else {
                planetsContainerView.show()
            }
            
        }
        
        clearView = !clearView
        
    }
    
    func zoomTo(body: JSON) {
        
        let node = wrapperNode.childNode(withName: body["name"].stringValue, recursively: false)!
        
        for node in wrapperNode.childNodes.filter({$0.name! != "orbit" && $0.name! != "Sun" && $0.name! != "Light"}){
            node.removeAllActions()
            node.runAction(SCNAction.move(to: node.position, duration: 0))
        }
        
        SCNTransaction.animationDuration = 2
        wrapperNode.removeAllAnimations()
        wrapperNode.scale = SCNVector3(1,1,1)
        wrapperNode.eulerAngles.y = 0
        
        let P = wrapperNode.convertPosition(node.position, to: scene.rootNode)
        let S = wrapperNode.convertPosition(sunNode.position, to: scene.rootNode)
        let C = sceneView.pointOfView!.position
        
        
        let SP = SCNVector3(P.x - S.x, 0, P.z - S.z)
        let SC = SCNVector3(C.x - S.x, 0, C.z - S.z)
        
        let i = SCNVector3.angleBetween(SP,SC) * SCNVector3.orientation(SP,SC)
        
        let scale = SC.length() / (SP.length() + bodyMulti * body["diameter"].float! * 2)
        self.scale = scale
        wrapperNode.eulerAngles.y += i
        wrapperNode.position = SCNVector3(0, C.y - 0.025, -1)
        wrapperNode.scale = SCNVector3(scale,scale,scale)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
             SCNTransaction.animationDuration = 0
        })
        
    }
    
    func reset(){
    
        SCNTransaction.animationDuration = 2
        wrapperNode.removeAllAnimations()
        wrapperNode.scale = SCNVector3(1,1,1)
        wrapperNode.position = SCNVector3(0, -0.2, -1)
        
        for (index,node) in wrapperNode.childNodes.filter({$0.name != "orbit" && $0.name != "Sun" && $0.name != "Light"}).enumerated() {
            
            let body = bodies.arrayValue[index]
            node.orbitAround(E: body["E"].float! , SMA: body["distance"].float! / 1000 * 149.6, period: body["period"].double!  * 10)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            SCNTransaction.animationDuration = 0
        })
    }
    
}

