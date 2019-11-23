//
//  ParkingCollectionViewController.swift
//  Find Your Parking
//
//  Created by student on 11/22/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit
import CloudKit

class ParkingCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    var supermarkets:Supermarkets!
    var parkingLot: Parkinglot!
    var slots: [Slot] = []
    var cellColor=true
    @IBOutlet weak var parkingCollectionView:UICollectionView!
    
    //It reloads every time when we view the collection class
    override func viewWillAppear(_ animated: Bool) {
        fetchSlotsOfParkinglot()
    }
    //fetches the slots of particular parking lot from the cloud
    @objc func  fetchSlotsOfParkinglot(){
        let parkinglotID=parkingLot.record.recordID
        let predicate = NSPredicate(format:"parkinglot == %@", parkinglotID)
        let query = CKQuery(recordType: "slot", predicate:predicate) // this gets *all* students
        Custodian.publicDatabase.perform(query, inZoneWith: nil){
            (records, error) in
            if let error = error {
                UIViewController.alert(title: "Disaster in fetchAllSlotsofParkingLots()", message:"\(error)")
                return
            } else {
                self.slots=[]
                if let slotRecords=records
                {
                    for slotRecord in slotRecords {          // here we map from CloudKit to our model
                        let slot = Slot(record:slotRecord)
                        self.slots.append(slot)
                        
                    }
                    DispatchQueue.main.async {
                        self.parkingCollectionView.reloadData()
                    }
                    print(self.slots.count)
                }
            }
        }
    }
    
    //Defines the number of sections in the collection view controller
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //defines the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slots.count
        
    }
    
    //Displays the availability and slot name of the each cell in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "slots", for: indexPath) as! ParkingCollectionViewCell
        let slotCell=slots[indexPath.item]
        cell.slotLBL.text=slotCell.slotNumber
        cell.backgroundColor=slotCell.isOccupied ? UIColor.lightGray:UIColor.green
        
        return cell
    }
    
    
    //Defines the function after selecting the particular cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
