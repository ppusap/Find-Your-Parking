//
//  SecondViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.title = "Map"
        tabBarItem.image = UIImage(named: "Map")
        
    }

}

