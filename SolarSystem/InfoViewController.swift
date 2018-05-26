//
//  InfoViewController.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/13/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Info {
    static var bodiesColors = [
        "Sun": #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
        "Mercury": #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1),
        "Venus": #colorLiteral(red: 0.8980392157, green: 0.4509803922, blue: 0.4509803922, alpha: 1),
        "Earth": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
        "Mars": #colorLiteral(red: 0.7176470588, green: 0.1098039216, blue: 0.1098039216, alpha: 1),
        "Jupiter": #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),
        "Saturn": #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
        "Uranus": #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
        "Neptune": #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
    ]
    
    
    static var mainColor: UIColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
}

class InfoViewController: UIViewController {

    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var distanceLabelAU: UILabel!
    @IBOutlet weak var distanceLabelKM: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var earthDiameterLabel: UILabel!
    @IBOutlet weak var planetDiameterLabel: UILabel!
    @IBOutlet weak var planetNameLabel: UILabel!
    
    var earthLayer = CAShapeLayer()
    var planetLayer = CAShapeLayer()
    var earthDiameterLayer = CAShapeLayer()
    var planetDiameterLayer = CAShapeLayer()
    var bodyLayer = CAShapeLayer()
    var sunLayer = CAShapeLayer()
    var sunDistanceLayer = CAShapeLayer()
    
    var earthRadius: CGFloat = 3
    
    var body: JSON! {
        didSet{
            
            bodyLayer.fillColor = Info.bodiesColors[body["name"].stringValue]!.cgColor
            
            distanceLabelAU.text = "\(body["distance"].stringValue) AU"
            distanceLabelKM.text = "\(body["distance"].doubleValue * 149.6) * 10^6 km"
            infoTextView.text = body["info"].stringValue
            
            let radius = earthRadius * CGFloat(body["diameter"].floatValue)
            
            if body["name"].stringValue != "Earth" {
            
                let center = CGPoint(
                    x: statisticsView.frame.width / 2 + ( statisticsView.frame.width / 2 - 8) / 2,
                    y: 170)
                planetLayer.path = UIBezierPath.circle(radius: radius, center: center)
                planetLayer.fillColor = Info.bodiesColors[body["name"].stringValue]!.cgColor
                
                planetDiameterLayer.path = UIBezierPath.line(A: CGPoint(x: center.x - radius, y: 130 ), B: CGPoint(x: center.x + radius, y: 130))
                planetDiameterLayer.strokeColor = Info.mainColor.cgColor
                planetDiameterLayer.fillColor = UIColor.clear.cgColor
                
                planetDiameterLabel.text = "\(12742 * body["diameter"].floatValue) km"
                planetNameLabel.text = body["name"].stringValue
                
                dayLabel.text = "\(body["rotationPeriod"].doubleValue) Earth days"
                yearLabel.text = "\(body["period"].doubleValue) Earth years"
            
            } else {
                planetLayer.path = nil
                planetDiameterLayer.path = nil
                planetDiameterLabel.text = ""
                planetNameLabel.text = ""
                
                dayLabel.text = " 23.93 hours"
                yearLabel.text = " 365.25 days"
            }
            
        }
    }
    
    func findLabel(in view: UIView){
        for V in view.subviews {
            findLabel(in: V)
            
            if V is UILabel {
                (V as! UILabel).textColor = Info.mainColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 8
        self.view.clipsToBounds = true
        
     
        for V in self.view.subviews {
            findLabel(in: V)
        }
        
        self.statisticsView.layer.addSublayer(sunLayer)
        self.statisticsView.layer.addSublayer(bodyLayer)
        self.statisticsView.layer.addSublayer(sunDistanceLayer)
        self.statisticsView.layer.addSublayer(earthLayer)
        self.statisticsView.layer.addSublayer(planetLayer)
        self.statisticsView.layer.addSublayer(earthDiameterLayer)
        self.statisticsView.layer.addSublayer(planetDiameterLayer)
//
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let earthCenter = CGPoint(
            x: 8 + ((statisticsView.frame.width / 2 - 8) / 2),
            y: 170)
        earthLayer.path = UIBezierPath.circle(radius: earthRadius, center: earthCenter)
        earthLayer.fillColor = Info.bodiesColors["Earth"]!.cgColor
        earthDiameterLayer.path = UIBezierPath.line(A: CGPoint(x: earthCenter.x - earthRadius, y: 130), B: CGPoint(x: earthCenter.x + earthRadius, y: 130))
        earthDiameterLayer.fillColor = UIColor.clear.cgColor
        earthDiameterLayer.strokeColor = Info.mainColor.cgColor
        earthDiameterLabel.text = "12742 km"
        
        sunLayer.fillColor = Info.bodiesColors["Sun"]!.cgColor
        sunLayer.path = UIBezierPath.circle(radius: 15, center: CGPoint(x: 23, y: 23))
        
        sunDistanceLayer.path = UIBezierPath.line(A: CGPoint(x: 40, y: 23), B: CGPoint(x: statisticsView.frame.width - 30, y: 23))
        sunDistanceLayer.strokeColor = Info.mainColor.cgColor
        sunDistanceLayer.fillColor = UIColor.clear.cgColor
        
        bodyLayer.path = UIBezierPath.circle(radius: 10, center: CGPoint(x: statisticsView.frame.width - 18, y: 23))
        
    }
    
}
