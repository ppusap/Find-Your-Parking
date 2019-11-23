//
//  ParkingLotTableViewController.swift
//  Find Your Parking
//
//  Created by Student on 11/11/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit
import CloudKit

class ParkingLotTableViewController: UITableViewController {
    
    var supermarkets:Supermarkets!
    var supermarket:Supermarket!
    var parkingLots:[Parkinglot]=[]
    
    //This method we defined all the properities of the navigation view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(supermarket.marketName)"
    }
    
    //It will reload the data each time when we view the table
    override func viewWillAppear(_ animated: Bool) {
        fetchParkingLotsOfSupermarket()
    }
    
    //Fetches the parkinglots of the particular supermarket
    @objc func  fetchParkingLotsOfSupermarket(){
        let supermarketID=supermarket.record.recordID
        let predicate = NSPredicate(format: "supermarket == %@", supermarketID)
        let query = CKQuery(recordType: "Parkinglot", predicate:predicate)
        Custodian.publicDatabase.perform(query, inZoneWith: nil){
            (records, error) in
            if let error = error {
                UIViewController.alert(title: "Disaster in fetchAllParkingLots()", message:"\(error)")
                return
            } else {
                self.parkingLots=[]
                if let parkinglotRecords=records
                {
                    for parkinglotRecord in parkinglotRecords {
                        let parkinglot = Parkinglot(record:parkinglotRecord)
                        self.parkingLots.append(parkinglot)
                    }
                    DispatchQueue.main.async {self.tableView.reloadData()}
                }
                
            }
        }
    }
    
    //Defines the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Defines the row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingLots.count
    }
    
    //Displays the name of the parking lot side
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingLotTVC", for: indexPath)
        cell.textLabel?.text = parkingLots[indexPath.row].parkingSide
        return cell
    }
    
    //Defines the function after selecting the specific cell in the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parkingLocations = storyboard?.instantiateViewController(withIdentifier: "ParkingCollectionVC") as! ParkingCollectionCustomViewController
        parkingLocations.parkingLot=parkingLots[indexPath.row]
        self.navigationController!.pushViewController(parkingLocations, animated: true)
    }

}
