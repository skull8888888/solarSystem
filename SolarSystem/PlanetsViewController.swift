//
//  PlanetsViewController.swift
//  SolarSystem
//
//  Created by Robert Kim on 1/11/18.
//  Copyright © 2018 Octopus. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlanetsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak private var collectionView: UICollectionView!
    
    var bodies: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlanetsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .clear
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return bodies.arrayValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlanetsCollectionViewCell
        
        if cell.body == nil {
            cell.body = bodies.arrayValue[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (UIScreen.main.bounds.width - 16) / 8, height: 100)
        }
        
        return indexPath.row < 4 ? CGSize(width: 50, height: 100): CGSize(width: 100, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let p = self.parent as! ViewController
        p.didChoosePlanet(index: indexPath.item)

    }

}
