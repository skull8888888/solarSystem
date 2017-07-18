//
//  ViewController.swift
//  SolarSystem
//
//  Created by Robert Kim on 7/15/17.
//  Copyright © 2017 Octopus. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

struct Body {
    var name: String!
    var mass: Double!
    var period: Double!
    var rotationPeriod: Double!
    var distance: CGFloat!
    var diameter: CGFloat!
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var bodies = [
        Body(name: "mercury", mass: 0.055, period: 0.24, rotationPeriod: 58.65, distance: 0.39, diameter: 0.382),
        Body(name: "venus", mass: 0.815, period: 0.62, rotationPeriod: 243, distance: 0.72, diameter: 0.949),
        Body(name: "earth", mass: 1.0, period: 1, rotationPeriod: 1, distance: 1.0, diameter: 1),
        Body(name: "mars", mass: 0.107, period: 1.88, rotationPeriod: 1.03, distance: 1.52, diameter: 0.532),
        Body(name: "jupiter", mass: 318, period: 11.86, rotationPeriod: 0.41, distance: 5.20, diameter: 11.209),
        Body(name: "saturn", mass: 95, period: 29.46, rotationPeriod: 0.44, distance: 9.54, diameter: 9.44),
        Body(name: "uranus", mass: 15, period: 84.01, rotationPeriod: 0.72, distance: 19.18, diameter: 4.007),
        Body(name: "neptune", mass: 17, period: 164.8, rotationPeriod: 0.72, distance: 30.06, diameter: 3.883),
    ]
    
    var sunNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let sunSphere = SCNSphere(radius: 0.1)
        sunSphere.firstMaterial?.diffuse.contents = UIImage(named:"art.scnassets/sunTexture.jpg")
        sunNode = SCNNode()
        sunNode.geometry = sunSphere
        sunNode.addAnimation(spinAnimation(duration: 10), forKey: "spin")
        sunNode.position = SCNVector3Make(0, 0, -1)
        
        scene.rootNode.addChildNode(sunNode)
        
        for body in bodies {
            
            let sphere = SCNSphere(radius: 0.005 * body.diameter)
            sphere.firstMaterial?.diffuse.contents = UIImage(named:"art.scnassets/\(body.name!)Texture.jpg")
        
            let node = SCNNode()//scene.rootNode.childNode(withName: body.name, recursively: true)!
            
            node.geometry = sphere
            node.position = SCNVector3Make(0, 0, -1)
            
            node.addAnimation(spinAnimation(duration: 3 * body.rotationPeriod), forKey: "spin")
            
            let moveAction = SCNAction.rotateAround(center: SCNVector3(0,0,-1), radius: 0.5 * body.distance, animationDuration: 10 * body.period)
            let repeatAction = SCNAction.repeatForever(moveAction)
            
            SCNTransaction.begin()
            node.runAction(repeatAction)
            SCNTransaction.commit()
            
            scene.rootNode.addChildNode(node)
        }
        
        
        
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    
    
    func spinAnimation(duration: Double) -> CABasicAnimation {

        let spin = CABasicAnimation(keyPath: "rotation")
        
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * CGFloat.pi)))
        spin.duration = duration
        spin.repeatCount = .infinity
        
        return spin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
   
    // MARK: - ARSCNViewDelegate

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
