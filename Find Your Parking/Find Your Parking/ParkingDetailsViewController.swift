//
//  SecondViewController.swift
//  Find Your Parking
//This database connection is did by Felipe Sato
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit

class ParkingDetailsViewController: UIViewController {
    var scanData:String?
    var supermarketName: String!
    
    @IBOutlet weak var superMarketNameLBL:UILabel!
    @IBOutlet weak var parkingLotLocationLBL:UILabel!
    @IBOutlet weak var parkingNumberLBL: UILabel!
    
    @IBAction func viewMap(_ sender: Any) {
        print("Button pressed")
        let sprmrktName = storyboard?.instantiateViewController(withIdentifier: "mapViewIDNV") as! UINavigationController
        let supermarketname = sprmrktName.topViewController as? MapViewController
        supermarketname?.supermarketName = supermarketName
//        switch supermarketName! {
//        case "walmart":
//            supermarketname?.supermarketName = .walmart
//        case "Hy-Vee":
//            supermarketname?.supermarketName = .hyvee
//        case "Dollar General":
//            supermarketname?.supermarketName = .dollarGeneral
//        default:
//            print(Error.self)
//        }
        print(supermarketName)
        
        //self.performSegue(withIdentifier:"ParkingViewSegue", sender: self)
        self.present(sprmrktName, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationController?.tabBarItem.title = "Where's my car?"
        self.navigationController?.tabBarItem.image = UIImage(named: "Map")

    }
    
    override func viewWillAppear(_ animated: Bool) {
         scanData = Supermarkets.shared.scanStorageData
               
               guard let displayData = scanData?.split(separator: "-") else{
                   return
               }
               
               if String(displayData[0]) == "w" || String(displayData[0]) == "W"{
                   superMarketNameLBL.text = "Walmart"
                   if String(displayData[1]) == "s" || String(displayData[1]) == "S"{
                       parkingLotLocationLBL.text = "South"
                       
                   }else if String(displayData[1]) == "n" || String(displayData[1]) == "N"{
                       parkingLotLocationLBL.text = "North"
                   }
                   else if String(displayData[1]) == "m" || String(displayData[1]) == "M"{
                       parkingLotLocationLBL.text = "Main"
                   }
                   else if String(displayData[1]) == "e" || String(displayData[1]) == "E"{
                       parkingLotLocationLBL.text = "East"
                   }
                   parkingNumberLBL.text = scanData
               }else if String(displayData[0]) == "h" || String(displayData[0]) == "H"{
                   superMarketNameLBL.text = "Hyvee"
                   if String(displayData[1]) == "s" || String(displayData[1]) == "S"{
                       parkingLotLocationLBL.text = "South"
                   }else if String(displayData[1]) == "n" || String(displayData[1]) == "N"{
                       parkingLotLocationLBL.text = "North"
                   }
                   else if String(displayData[1]) == "m" || String(displayData[1]) == "M"{
                       parkingLotLocationLBL.text = "Main"
                   }
                   else if String(displayData[1]) == "e" || String(displayData[1]) == "E"{
                       parkingLotLocationLBL.text = "East"
                   }
                   parkingNumberLBL.text = scanData
               }else if String(displayData[0]) == "d" || String(displayData[0]) == "D"{
                   superMarketNameLBL.text = "Dollar General"
                   if String(displayData[1]) == "s" || String(displayData[1]) == "S"{
                       parkingLotLocationLBL.text = "South"
                   }else if String(displayData[1]) == "n" || String(displayData[1]) == "N"{
                       parkingLotLocationLBL.text = "North"
                   }
                   else if String(displayData[1]) == "m" || String(displayData[1]) == "M"{
                       parkingLotLocationLBL.text = "Main"
                   }
                   else if String(displayData[1]) == "e" || String(displayData[1]) == "E"{
                       parkingLotLocationLBL.text = "East"
                   }
                   parkingNumberLBL.text = scanData
               }
               else if String(displayData[0]) == "t" || String(displayData[0]) == "T"{
                   superMarketNameLBL.text = "Target"
                   if String(displayData[1]) == "s" || String(displayData[1]) == "S"{
                       parkingLotLocationLBL.text = "South"
                   }else if String(displayData[1]) == "n" || String(displayData[1]) == "N"{
                       parkingLotLocationLBL.text = "North"
                   }
               
                   parkingNumberLBL.text = scanData
               }

           }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.tabBarItem.title = "Map"
//        self.navigationController?.tabBarItem.image = UIImage(named: "Map")
        navigationItem.title = "Details of Parking"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
       
}
}
