//
//  Locations.swift
//  Find Your Parking
//
//  Created by Student on 10/5/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import Foundation

//struct ParkingLots {
//    var locationName: String
//
//    // other properties omitted .. this is just a demo
//}


struct SuperMarketDetails{
    var marketName:String!
    var hours: String
    var parkingLotLocation:[String] = []
}
class SuperMarkets {
    
    
    private static var _shared:SuperMarkets!
    static var shared:SuperMarkets{
        if _shared == nil{
            _shared = SuperMarkets()
        }
        return _shared
    }
    
    private init(){}
    
    //    init(marketName:String, hours: String, parkingLotLocation:[ParkingLots] = []){
    //        self.marketName = marketName
    //        self.hours = hours
    //        self.parkingLotLocation = parkingLotLocation
    //    }
    
    private var maryvilleSuperMarkets = [
        SuperMarketDetails(marketName: "WalMaart", hours: "Open 24/7", parkingLotLocation: ["Main ParkingLot"]),
        SuperMarketDetails(marketName: "HyVee", hours: "Open 24/7", parkingLotLocation: ["Main ParkingLot"]),
        SuperMarketDetails(marketName: "Dollar General", hours: "8:00AM - 21:00PM", parkingLotLocation: ["Main ParkingLot"])
    ]
    
    // just a convenience so we can access each restaurant's menu more easily
    subscript (i:Int) -> SuperMarketDetails{
        return maryvilleSuperMarkets[i]
    }
    
    func numSuparkets() -> Int {
        return maryvilleSuperMarkets.count
    }
    
    
}

