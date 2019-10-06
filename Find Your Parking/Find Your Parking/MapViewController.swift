//
//  SecondViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var locationLBL: UILabel!
    
    @IBOutlet weak var hoursLBL: UILabel!
    
    @IBAction func directions(_ sender: UIButton) {
        let parkingVC = self.storyboard?.instantiateViewController(withIdentifier: "ParkingViewController") as! ParkingViewController
        self.navigationController?.pushViewController(parkingVC, animated: true)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.title = "Map"
        tabBarItem.image = UIImage(named: "Map")
        
    }
    
    
}





