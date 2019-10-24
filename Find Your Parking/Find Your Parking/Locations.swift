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

class SuperMarketDetails:Equatable,CKRecordValueProtocol,Hashable{
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
        let SuperMarketDetailsRecordId = CKRecord.ID(recordName: "\(marketName)")                    // 1. create a record ID
        self.record = CKRecord(recordType: "SuperMarketDetails", recordID: SuperMarketDetailsRecordId)  // 2. create a record using that record ID
        self.record["marketName"] = marketName
        self.record["hours"] = "hours"
        self.marketName = marketName
        self.hours = hours
        
    }
    
    // Two teachers are deemed equal if they have the same ssn
    static func==(lhs:SuperMarketDetails,rhs:SuperMarketDetails)->Bool {
        return lhs.marketName == rhs.marketName
    }
    
    
    
    
}

class DetailLocation:Equatable{
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
    var superMarketDetails:CKRecord.Reference!{
        get{
            return record["superMarketDetails"]
        }
        set(superMarketDetails){
            record["superMarketDetails"]=superMarketDetails
        }
    }
    init (record:CKRecord)
    {
        self.record=record
    }
    init(parkingLocation:String,superMarketDetails:CKRecord.Reference?){
        let parkingLocationId = CKRecord.ID(recordName:"\(parkingLocation)")
        self.record=CKRecord(recordType: "DetailLocation", recordID: parkingLocationId)
        self.parkingLocation=parkingLocation
        self.superMarketDetails=superMarketDetails
    }
    static func == (lhs:DetailLocation,rhs:DetailLocation)->Bool{
        return lhs.parkingLocation==rhs.parkingLocation
    }
}
class SuperMarkets {
    
    
    private static var _shared:SuperMarkets!
    
    var detailLocation:[DetailLocation]=[]
    var superMarketDetails:[SuperMarketDetails]=[]
    
    static var shared:SuperMarkets{
        if _shared == nil{
            _shared = SuperMarkets()
        }
        return _shared
    }
    
    private init(){}
    
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
                SuperMarkets.shared.superMarketDetails=[]
                for marketRecords in superMarketDetailsRecords!{
                    let details=SuperMarketDetails(record: marketRecords)
                    SuperMarkets.shared.superMarketDetails.append(details)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"All Super Markets are Fetched"), object: nil)
            }
            
        }
    }
    
    func populateCloudKitDatabase(){
        
        var location:[SuperMarketDetails:[DetailLocation]]
        superMarketDetails=[SuperMarketDetails(marketName: "Walmart", hours: "8AM-12PM") ,SuperMarketDetails(marketName: "Hyvee", hours: "8AM-12PM"),
                            SuperMarketDetails(marketName: "Dollar General", hours: "8AM-12PM")]
        
        detailLocation=[DetailLocation(parkingLocation: ("North Side"), superMarketDetails: nil),
                        DetailLocation(parkingLocation: ("South Side"), superMarketDetails: nil),
                        DetailLocation(parkingLocation: ("Main Parking Lot"), superMarketDetails: nil),
                        DetailLocation(parkingLocation: ("East Side"), superMarketDetails: nil)]
        
        location=[superMarketDetails[0]:[detailLocation[0],detailLocation[1],detailLocation[2]],
                  superMarketDetails[1]:[detailLocation[0],detailLocation[1],detailLocation[2]],
                  superMarketDetails[2]:[detailLocation[0],detailLocation[1],detailLocation[2]]]
        
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
