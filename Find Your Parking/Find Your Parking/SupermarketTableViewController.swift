//
//  SupermarketTableViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit
import CloudKit

class SupermarketTableViewController: UITableViewController {

    //This method we defined all the properities of the navigation view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Your Location"
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedAllSupermarkets), name: NSNotification.Name("All Supermarket Fetched"), object: nil)
        checkForLogin()
    }
    
    //It will reload the data each time when we view the table
    override func viewWillAppear(_ animated: Bool) {
        fetchAllSupermarkets()
    }
    //It will fetch all the supermarkets from the cloud
    @objc func fetchAllSupermarkets(){
        Supermarkets.shared.callSupermarket()
    }
    //Checks for the icloud login
    func checkForLogin(){
        
        Custodian.defaultContainer.accountStatus(){
            (accountStatus, error) in
            if accountStatus == .noAccount {
                DispatchQueue.main.async {
                    UIViewController.alert(title: "Sign in to iCloud", message: "Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.")
                }
            }
        }
    }
    //Defines tab bar properties for this table view controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem.title = "Parking Lots"
        tabBarItem.image = UIImage(named: "car")
        
    }
    
    //Reloads data after fetching from the cloud
    @objc func fetchedAllSupermarkets(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Defines number of sections in the table view controller
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Defines the count of the supermarkets
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Supermarkets.shared.supermarket.count
    }
    
    //Displays the supermarket Name in the each row of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationTVC", for: indexPath)
        
        cell.textLabel?.text = Supermarkets.shared.supermarket[indexPath.row].marketName
        
        return cell
    }
    
    //Defines the function after selecting the row in the table view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slots = storyboard?.instantiateViewController(withIdentifier: "ParkingLotTVC") as! ParkingLotTableViewController
        slots.supermarket=Supermarkets.shared.supermarket[indexPath.row]
        self.navigationController!.pushViewController(slots, animated: true)
    }
}
