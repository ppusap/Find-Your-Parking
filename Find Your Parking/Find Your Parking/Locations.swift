//
//  Locations.swift
//  Find Your Parking
//
//  Created by Student on 10/5/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//
// We will create private database in next Milestone
import Foundation
import CloudKit
import UIKit


extension UIViewController {
    
    static func alert(title:String, message:String){
        
        DispatchQueue.main.async {
            let topViewController = UIApplication.shared.keyWindow!.rootViewController!
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(action)
            topViewController.present(ac, animated:true)
        }
    }
}

/// Custodian keeps track of the databases for us
class Custodian {
    static var defaultContainer:CKContainer = CKContainer.default()
    static var publicDatabase:CKDatabase = defaultContainer.publicCloudDatabase
    static var privateDatabase:CKDatabase = defaultContainer.privateCloudDatabase
    static var anotherDatabase = CKContainer(identifier: "").publicCloudDatabase
}

//
//struct ParkingLots {
//    var locationName: String
//    var locationNumber:String
//
////    // other properties omitted .. this is just a demo
//}


//struct SuperMarketDetails{
//    var marketName:String!
//    var hours: String
//    var parkingLotLocation :(locationName:String,locationNumber:String)
//}

class SuperMarket:Equatable,CKRecordValueProtocol,Hashable{
    var record:CKRecord!
    
    func hash(into hasher:inout Hasher)
    {
        hasher.combine(marketName)
    }
    var marketName:String{
        get {
            return record["marketName"]!
        }
        set(marketName)
        {
            record["marketName"]=marketName
        }
        
    }
    var hours: String{
        get {
            return record["hours"]!
        }
        
        set(hours){
            record["hours"] = hours
        }
    }
    //var parkingLocation:(locationName:String locationNumber:Int)
    
    init(record:CKRecord){
        self.record = record
    }
    
    init(marketName:String, hours:String){
        let SuperMarketsRecordId = CKRecord.ID(recordName: "\(marketName)")                    // 1. create a record ID
        self.record = CKRecord(recordType: "SuperMarketDetails", recordID: SuperMarketsRecordId)  // 2. create a record using that record ID
        self.record["marketName"] = marketName
        self.record["hours"] = "hours"
        self.marketName = marketName
        self.hours = hours
        
    }
    
    // Two teachers are deemed equal if they have the same ssn
    static func==(lhs:SuperMarket,rhs:SuperMarket)->Bool {
        return lhs.marketName == rhs.marketName
    }
    
    
    
    
}

class ParkingLotLocation:Equatable{
    var record:CKRecord!
    var parkingLocation:String //May change this later
    {
        get{
            return record["parkingLocation"]!
        }
        set(parkingLocation){
            record["parkingLocation"]=parkingLocation
            
        }
    }
    var slot:String { // actual identification of each parking slot (e.g., A1, A2 or whatever)
        get {
            return record["slot"]!
        }
        set(slot){
            record["slot"] = slot
        }
    }
    var isOccupied:Bool {
        get {
            return record["isOccupied"]!
        }
        set(isOccupied){
            record["isOccupied"] = isOccupied
        }
    }
    var superMarkets:CKRecord.Reference!{
        get{
            return record["superMarkets"]
        }
        set(superMarkets){
            record["superMarkets"]=superMarkets
        }
    }
    init (record:CKRecord)
    {
        self.record=record
    }
    init(parkingLocation:String,superMarkets:CKRecord.Reference?){
        let parkingLocationId = CKRecord.ID(recordName:"\(parkingLocation)")
        self.record=CKRecord(recordType: "ParkingLotLocation", recordID: parkingLocationId)
        self.parkingLocation=parkingLocation
        self.superMarkets=superMarkets
    }
    static func == (lhs:ParkingLotLocation,rhs:ParkingLotLocation)->Bool{
        return lhs.parkingLocation==rhs.parkingLocation
    }
}
class SuperMarkets {
    
    
    private static var _shared:SuperMarkets!
    
    var parkingLotLocation:[ParkingLotLocation]=[]
    var superMarkets:[SuperMarket]=[]
    
    static var shared:SuperMarkets{
        if _shared == nil{
            _shared = SuperMarkets()
        }
        return _shared
    }
    
    private init(){
        populateCloudKitDatabase()
    }
    
    //    init(marketName:String, hours: String, parkingLotLocation:[ParkingLots] = []){
    //        self.marketName = marketName
    //        self.hours = hour
    //        self.parkingLotLocation = parkingLotLocation
    //    }
    
    func fetchAllSuperMarketDetails(){
        let query = CKQuery(recordType: "SuperMarketDetails", predicate: NSPredicate(value: true))
        Custodian.publicDatabase.perform(query, inZoneWith: nil){
            (superMarketDetailsRecords,error) in
            if let error = error{
                UIViewController.alert(title: "Disaster while fetching Super Market Details", message:"\(error)")
            }
            else
            {
                SuperMarkets.shared.superMarkets=[]
                for marketRecords in superMarketDetailsRecords!{
                    let details=SuperMarket(record: marketRecords)
                    SuperMarkets.shared.superMarkets.append(details)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"All Super Markets are Fetched"), object: nil)
            }
            
        }
    }
    
    func populateCloudKitDatabase(){
        
        var location:[SuperMarket:[ParkingLotLocation]]
        superMarkets=[SuperMarket(marketName: "Walmart", hours: "8AM-12PM") ,SuperMarket(marketName: "Hyvee", hours: "8AM-12PM"),
                            SuperMarket(marketName: "Dollar General", hours: "8AM-12PM")]
        
        parkingLotLocation=[ParkingLotLocation(parkingLocation: ("North Side"), superMarkets: nil),
                        ParkingLotLocation(parkingLocation: ("South Side"), superMarkets: nil),
                        ParkingLotLocation(parkingLocation: ("Main Parking Lot"), superMarkets: nil),
                        ParkingLotLocation(parkingLocation: ("East Side"), superMarkets: nil)]
        
        location=[superMarkets[0]:[parkingLotLocation[0],parkingLotLocation[1],parkingLotLocation[2]],
                  superMarkets[1]:[parkingLotLocation[0],parkingLotLocation[1],parkingLotLocation[2]],
                  superMarkets[2]:[parkingLotLocation[0],parkingLotLocation[1],parkingLotLocation[2]]]
        
        //        for(superMarketDetails,detailLocation) in location
        //        {
        //            Custodian.publicDatabase.save(superMarketDetails.record){
        //                (record,error) in
        //                if let error = error {
        //                    UIViewController.alert(title: "Disaster while saving teachers", message:"\(error)")
        //                } else {
        //                    UIViewController.alert(title:"Success, saved teacher", message:"")
        //                    for details in detailLocation
        //                    {
        //                        details.superMarketDetails=CKRecord.Reference(recordID: superMarketDetails.record.recordID, action: .deleteSelf)
        //
        //
        //                        Custodian.privateDatabase.save(details.record){
        //                            (record, error) in
        //                            if let error = error {
        //                                UIViewController.alert(title:"Disaster while Fetching the parking Locations", message:"\(error)")
        //                            } else {
        //                                UIViewController.alert(title:"Success, saved student \(details.parkingLocation)", message:"")
        //                            }
        //                        }
        //                    }
        //
        //                }
        //            }
        //        }
        
        
        
        
        
        
        
        
        
        //    private var maryvilleSuperMarkets = [
        //        SuperMarketDetails(marketName: "WalMaart", hours: "Open 24/7", parkingLotLocation: ["Main ParkingLot","A10"]),
        //        SuperMarketDetails(marketName: "HyVee", hours: "Open 24/7", parkingLotLocation: ["Main ParkingLot","B20"]),
        //        SuperMarketDetails(marketName: "Dollar General", hours: "8:00AM - 21:00PM", parkingLotLocation: ["Main ParkingLot","C10"])
        //    ]
        
        // just a convenience so we can access each restaurant's menu more easily
        
        
    }
    
}
