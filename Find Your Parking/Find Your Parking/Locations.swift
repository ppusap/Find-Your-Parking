
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

// Custodian keeps track of the databases for us
class Custodian {
    static var defaultContainer:CKContainer = CKContainer.default()
    static var publicDatabase:CKDatabase = defaultContainer.publicCloudDatabase
    static var privateDatabase:CKDatabase = defaultContainer.privateCloudDatabase
    static var anotherDatabase = CKContainer(identifier: "").publicCloudDatabase
}

// A class supermarket to store supermarket details

class Supermarket:Equatable,CKRecordValueProtocol,Hashable
{
    var record:CKRecord!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(marketID)
    }
    var marketID:String{
        get
        {
            return record["marketID"]!
        }
        set(marketID)
        {
            record["marketID"]=marketID
        }
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
    
    init(record:CKRecord){
        self.record = record
    }
    
    init(marketID:String,marketName:String,hours:String)
    {
        let supermarketRecordId = CKRecord.ID(recordName: marketID)
        self.record=CKRecord(recordType: "SuperMarkets", recordID: supermarketRecordId)
        self.record["marketID"]=marketID
        self.record["marketName"]=marketName
        self.marketID=marketID
        self.marketName=marketName
        self.hours=hours
        
    }
    
    static func==(lhs:Supermarket,rhs:Supermarket)->Bool {
        return lhs.marketID == rhs.marketID
    }
    
}


// A class Parking Lot to store supermarket details

class Parkinglot:Equatable,Hashable
{
    var record: CKRecord!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(parkinglotID)
    }
    var parkinglotID:Int
    {
        get
        {
            return record["parkinglotID"]!
        }
        set(parkinglotID)
        {
            record["parkinglotID"]=parkinglotID
        }
    }
    var parkingSide:String
    {
        get
        {
            return record["parkingSide"]!
        }
        set(parkingSide)
        {
            record["parkingSide"]=parkingSide
        }
    }
    var supermarket:CKRecord.Reference!{
        get{
            return record["supermarket"]
        }
        set(supermarket){
            record["supermarket"]=supermarket
        }
    }
    init (record:CKRecord)
    {
        self.record=record
    }
    init(parkinglotID:Int,parkingSide:String,supermarket:CKRecord.Reference?){
        let parkinglotRecordId = CKRecord.ID(recordName:"\(parkinglotID)")
        self.record=CKRecord(recordType: "Parkinglot", recordID: parkinglotRecordId)
        self.parkinglotID=parkinglotID
        self.parkingSide=parkingSide
        self.supermarket=supermarket
    }
    
    
    static func == (lhs: Parkinglot, rhs: Parkinglot) -> Bool {
        return lhs.parkinglotID == rhs.parkinglotID
    }
    
    
}

// A class Slot to store supermarket details

class Slot:Equatable
{
    var record: CKRecord!
    
    var slotNumber:String
    {
        get
        {
            return record["slotNumber"]!
        }
        set(slotNumber)
        {
            record["slotNumber"]=slotNumber
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
    
    var parkinglot:CKRecord.Reference!{
        get{
            return record["parkinglot"]
        }
        set(parkinglot){
            record["parkinglot"]=parkinglot
        }
    }
    init (record:CKRecord)
    {
        self.record=record
    }
    init(slotNumber:String,isOccupied:Bool,parkinglot:CKRecord.Reference?){
        let slotRecordId = CKRecord.ID(recordName:"\(slotNumber)")
        self.record=CKRecord(recordType: "slot", recordID: slotRecordId)
        self.slotNumber=slotNumber
        self.isOccupied=isOccupied
        self.parkinglot=parkinglot
    }
    
    static func == (lhs: Slot, rhs: Slot) -> Bool {
        return lhs.slotNumber == rhs.slotNumber
    }
    
    
}

// A singleton model class.

class Supermarkets{
    private static var _shared: Supermarkets!
    var supermarket:[Supermarket]=[]
    var parkinglot:[Parkinglot]=[]
    var slot:[Slot]=[]
    var scanStorageData:String="0-0-0"
     var displayMapDetails:String=""
    static var shared: Supermarkets {
        if _shared == nil {
            _shared = Supermarkets()
        }
        
        return _shared
    }
    
    private init(){
        //populateCloudKitDatabase()
    }
    
    func callSupermarket(){
        let query = CKQuery(recordType: "SuperMarkets", predicate: NSPredicate(value:true)) // this gets *all* students
        Custodian.publicDatabase.perform(query, inZoneWith: nil){
            (supermarketRecords, error) in
            if let error = error {
                UIViewController.alert(title: "Disaster in fetchAllSupermarkets()", message:"\(error)")
            } else {
                Supermarkets.shared.supermarket = [ ] // clear array in model
                for supermarketRecord in supermarketRecords! {          // here we map from CloudKit to our model
                    let supermarket = Supermarket(record:supermarketRecord)
                    Supermarkets.shared.supermarket.append(supermarket)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"All Supermarket Fetched"), object: nil)
            }
        }
    }
    
    func callSlots(){
        let query = CKQuery(recordType: "slot", predicate: NSPredicate(value:true)) // this gets *all* students
        Custodian.publicDatabase.perform(query, inZoneWith: nil){
            (slotRecords, error) in
            if let error = error {
                UIViewController.alert(title: "Disaster in fetchAllSlots()", message:"\(error)")
            } else {
                Supermarkets.shared.slot = [ ] // clear array in model
                for slotRecord in slotRecords! {          // here we map from CloudKit to our model
                    let slot = Slot(record:slotRecord)
                    Supermarkets.shared.slot.append(slot)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"All Slots Fetched"), object: nil)
            }
        }
    }
    
    // A function to populate data into the cloudkit
    
    func populateCloudKitDatabase(){
        
        var parkingSpotsInSuperMarket: [Supermarket:[Parkinglot:[Slot]]]
        
        supermarket=[
            Supermarket(marketID:"Pking_Walmart",marketName: "Walmart", hours: "9AM-11PM") ,
            Supermarket(marketID:"Pking_HyVee",marketName: "HyVee", hours: "10AM-12PM"),
            Supermarket(marketID:"Pking_Dollar General",marketName: "Dollar General", hours: "8AM-12PM"),
            Supermarket(marketID: "Pking_Target", marketName: "Target", hours: "8AM-9PM")
        ]
        
        parkinglot=[
            Parkinglot(parkinglotID:111101,parkingSide: "North Side", supermarket: nil),
            Parkinglot(parkinglotID:111102,parkingSide: "South Side", supermarket: nil),
            Parkinglot(parkinglotID:111103,parkingSide: "Main Side",  supermarket: nil),
            Parkinglot(parkinglotID:111104,parkingSide: "East Side", supermarket: nil),
            
            Parkinglot(parkinglotID:111105,parkingSide: "North Side", supermarket: nil),
            Parkinglot(parkinglotID:111106,parkingSide: "South Side", supermarket: nil),
            Parkinglot(parkinglotID:111107,parkingSide: "Main Side",  supermarket: nil),
            Parkinglot(parkinglotID:111108,parkingSide: "East Side", supermarket: nil),
            
            Parkinglot(parkinglotID:111109,parkingSide: "North Side", supermarket: nil),
            Parkinglot(parkinglotID:111110,parkingSide: "South Side", supermarket: nil),
            Parkinglot(parkinglotID:111111,parkingSide: "Main Side",  supermarket: nil),
            Parkinglot(parkinglotID:111112,parkingSide: "East Side", supermarket: nil),
            
            Parkinglot(parkinglotID:111113,parkingSide: "North Side", supermarket: nil),
            Parkinglot(parkinglotID:111114,parkingSide: "South Side", supermarket: nil)
            
            
        ]
        
        slot =  [Slot(slotNumber: "w-n-1", isOccupied: true,parkinglot:nil),
                 Slot(slotNumber: "w-n-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-s-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-s-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-m-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-m-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-e-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "w-e-2", isOccupied: false,parkinglot:nil),
                 
                 Slot(slotNumber: "h-n-1", isOccupied: true,parkinglot:nil),
                 Slot(slotNumber: "h-n-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-s-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-s-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-m-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-m-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-e-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "h-e-2", isOccupied: false,parkinglot:nil),
                 
                 Slot(slotNumber: "d-n-1", isOccupied: true,parkinglot:nil),
                 Slot(slotNumber: "d-n-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-s-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-s-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-m-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-m-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-e-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "d-e-2", isOccupied: false,parkinglot:nil),
                 
                 Slot(slotNumber: "t-n-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "t-n-2", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "t-s-1", isOccupied: false,parkinglot:nil),
                 Slot(slotNumber: "t-s-2", isOccupied: false,parkinglot:nil)
            
            
            
        ]
        
        parkingSpotsInSuperMarket =
            [
                supermarket[0]:
                    [parkinglot[0]:[slot[0], slot[1]],
                     parkinglot[1]:[slot[2], slot[3]],
                     parkinglot[2]:[slot[4], slot[5]],
                     parkinglot[3]:[slot[6], slot[7]]],
                
                supermarket[1]:
                    [parkinglot[4]:[slot[8], slot[9]],
                     parkinglot[5]:[slot[10], slot[11]],
                     parkinglot[6]:[slot[12], slot[13]],
                     parkinglot[7]:[slot[14], slot[15]]],
                
                supermarket[2]:
                    [parkinglot[8]:[slot[16], slot[17]],
                     parkinglot[9]:[slot[18], slot[19]],
                     parkinglot[10]:[slot[20], slot[21]],
                     parkinglot[11]:[slot[22], slot[23]]]
                
        ]
        
        var parkingSpotsInSuperMarket2: [Supermarket:[Parkinglot:[Slot]]]
        
        parkingSpotsInSuperMarket2 =
            [
                supermarket[3]:
                    [parkinglot[12]:[slot[24], slot[25]],
                     parkinglot[13]:[slot[26], slot[27]]]
        ]
        
        for (supermarket, parkinglots) in parkingSpotsInSuperMarket2 {
            
            
            Custodian.publicDatabase.save(supermarket.record){             // 4. save the record (after having gotten the container, and container.publicCloudDatabase
                
                (record, error) in                                                      // handle things going wrong
                if let error = error {
                    UIViewController.alert(title: "Disaster while saving teachers", message:"\(error)")
                } else {
                    UIViewController.alert(title:"Success, saved supermarket", message:"")
                }
            }
            for (parkinglot, slots) in parkinglots{
                
                parkinglot.supermarket = CKRecord.Reference(recordID: supermarket.record.recordID, action: .deleteSelf) // every student points to their teacher
                
                
                // 2. Create a reference object by passing the target record's id as a parameter ...
                // 3. ... and adding the reference to the source record
                
                // 4. Save the record
                Custodian.publicDatabase.save(parkinglot.record){
                    (record, error) in
                    if let error = error {
                        UIViewController.alert(title:"Disaster while saving parking lots", message:"\(error)")
                    } else {
                        UIViewController.alert(title:"Success, saved parking lot\(parkinglot.parkinglotID)", message:"")
                    }
                }
                
                for slot in slots{
                    
                    slot.parkinglot = CKRecord.Reference(recordID: parkinglot.record.recordID, action: .deleteSelf) // every student points to their teacher
                    
                    
                    // 2. Create a reference object by passing the target record's id as a parameter ...
                    // 3. ... and adding the reference to the source record
                    
                    // 4. Save the record
                    Custodian.publicDatabase.save(slot.record){
                        (record, error) in
                        if let error = error {
                            UIViewController.alert(title:"Disaster while saving students", message:"\(error)")
                        } else {
                            UIViewController.alert(title:"Success, saved slot \(slot.slotNumber)", message:"")
                        }
                    }
                    
                }
            }
        }
    }
    
    
}

