//
//  LocationsTableViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    
    var superMarket:SuperMarkets!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Your Location"
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //added titlehihello
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem.title = "Parking Lots"
        tabBarItem.image = UIImage(named: "car")
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SuperMarkets.shared.numSuparkets()
    }
    
    
    
    
  
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        
        //Configure the cell...
        let locations = SuperMarkets.shared[indexPath.row]
        cell.textLabel?.text = locations.marketName
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              // 1. Instantiate a MenuTableViewController
        var slots = storyboard!.instantiateViewController(withIdentifier: "ParkingViewController") as! ParkingCollectionViewController
        
                // 2. Configure its Restaurant
        
               // menuTVC.restaurant = FoodCourt.shared[indexPath.row]
       // slots=SuperMarkets.shared[indexPath.row]
                // 3. Push it on to the navigation controller's stack
        
                self.navigationController!.pushViewController(slots, animated: true)
            }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
