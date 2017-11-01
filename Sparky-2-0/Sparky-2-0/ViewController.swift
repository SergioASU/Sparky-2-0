//
//  ViewController.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/23/17.
//  Copyright © 2017 Overlord Sergio Corral. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var stationTable: UITableView!
    @IBOutlet weak var waterFactsLabel: UILabel!
    
    let rootRef = Database.database().reference()
    var refWater: DatabaseReference!
    var switchInt: Int = 0
    
    var waterStationRepo: WaterStationDatabase = WaterStationDatabase()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        refWater = Database.database().reference().child("stations");
        
        let key = refWater.childByAutoId().key
        
        //creating artist with the given values
       /* let station = ["stationKey": key,
                       "stationName":"Hayden Library Concord",
                       "stationDesc": "Underground Level",
                       "stationRating": "4",
                       "stationLong": "878",
                       "stationLat" : "726.462"
        ] as [String : Any]
        
        //adding the artist inside the generated unique key
        refWater.child(key).setValue(station)
        */
        //observing the data changes
        refWater.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.waterStationRepo.waterStationArray.removeAll()
                
                //iterating through all the values
                for stations in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let stationObject = stations.value as? [String: AnyObject]
                    let stationKey  = stationObject?["stationKey"]
                    let stationName  = stationObject?["stationName"]
                    let stationDesc = stationObject?["stationDesc"]
                    let stationRating = stationObject?["stationRating"]
                    let stationLong = stationObject?["stationLong"]
                    let stationLat = stationObject?["stationLat"]
                    
                    //creating artist object with model and fetched values
                    let station = WaterStation(k: stationKey as! String, n: stationName as! String, d: stationDesc as! String, r: stationRating as! String, lon: stationLong as! String, lat: stationLat as! String)
                    
                    //appending it to list
                    self.waterStationRepo.addWaterStation(w: station)
                }
                
                //reloading the tableview
                self.stationTable.reloadData()
            }
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // disappear keyboard when tap somehere else in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return waterStationRepo.waterStationArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StationCell
            let station = waterStationRepo.waterStationArray[indexPath.row]
            cell.layer.borderWidth = 1.0
            cell.stationNameLabel.text =
                station.name
            
            cell.stationRatingLabel.text = station.rating
            
            
            return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        /*let placeEntity = "Place" //Entity Name
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let place = places.places[indexPath.row]
        if(editingStyle == .delete)
        {
            managedContext.delete(place)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        
        //Code to Fetch New Data From The DB and Reload Table.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: placeEntity)
        
        do {
            places.places = try managedContext.fetch(fetchRequest) as! [Place]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        Table.reloadData()*/
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in }))
        
        self.present(alert,animated: true, completion: nil)
    }
    
    
    @IBAction func FindStationPressed(_ sender: Any)
    {
        //performSegue(withIdentifier: "segueToDetailView", sender: self)
        /*
        UIView.animate(withDuration: 20, animations: {
            self.waterFactsLabel.center = CGPoint(x: self.waterFactsLabel.center.x-200, y:self.waterFactsLabel.center.y)
        })    }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchInt = indexPath.row
        performSegue(withIdentifier: "segueToDetailView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.station = waterStationRepo.waterStationArray[switchInt]
        
    }

    
}

