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
import SwiftyJSON

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var planetsContainerView: UIView!
    
    @IBOutlet weak var infoContainerView: UIView!
    
    @IBOutlet weak var infoContainerViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoContainerViewHeightConstraint: NSLayoutConstraint!
    
    var scene: SCNScene!
    
    var bodyMulti: Float = 0.01
    var distanceMulti: Float = 149.6 / 1000
    
    var bodies: JSON!
    var wrapperNode: SCNNode!
    var sunNode: SCNNode!
    var pinchGR: UIPinchGestureRecognizer!
    var tapGR: UITapGestureRecognizer!
    
    var scale: Float = 1
    var minScale: Float = 0.1
    var maxScale: Float = 20
    
    var selectedPlanet = false
    var clearView = false
    var showInfo = false
    
    lazy var planetsViewController: PlanetsViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? PlanetsViewController }).first!
    }()
    
    lazy var infoViewController: InfoViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? InfoViewController }).first!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            infoContainerViewRightConstraint.constant = self.view.frame.width / 2
        }
    

        infoButton.blur()
        infoButton.layer.cornerRadius = 20
        infoButton.clipsToBounds = true
        infoButton.bringSubview(toFront: infoButton.imageView!)
        infoButton.isHidden = true
        resetButton.blur()
        resetButton.layer.cornerRadius = 20
        resetButton.clipsToBounds = true
        resetButton.bringSubview(toFront: resetButton.imageView!)
        resetButton.isHidden = true
        
        infoContainerView.hide()
        
        scene = SCNScene()
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                bodies = JSON(data: data)["planets"]
                planetsViewController.bodies = bodies!
            } catch {
                print("error in parsing JSON")
            }
        }
        
        setPlanets()
        
        pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(gesture:)))
        tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        
        sceneView.delegate = self
        sceneView.addGestureRecognizer(pinchGR)
        sceneView.addGestureRecognizer(tapGR)
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func didChoosePlanet(index: Int) {
        
        self.selectedPlanet = true
        let body = bodies.arrayValue[index]
        
        zoomTo(body: body)
        infoViewController.body = body
    
        if infoButton.isHidden {
            infoButton.show()
        }
        
        if resetButton.isHidden {
            resetButton.show()
        }
    }
    
    @IBAction func resetPositionButtonTapped(_ sender: Any) {
        
        selectedPlanet = false
        showInfo = false
        
        reset()
        infoContainerView.hide()
        resetButton.hide()
        infoButton.hide()
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        showInfo = !showInfo
        infoContainerView.toggle()
        infoButton.tintColor = #colorLiteral(red: 0.994279325, green: 0.8076760173, blue: 0.2781653404, alpha: 1)
    }

}
