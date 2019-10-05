//
//  FirstViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit

class QRReaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.title = "QR Scanner"
        tabBarItem.image = UIImage(named: "QR")
        
    }
}

