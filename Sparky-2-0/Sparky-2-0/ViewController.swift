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

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var stationTable: UITableView!
    @IBOutlet weak var waterFactsLabel: UILabel!

    let rootRef = Database.database().reference()
    var refWater: DatabaseReference!
    var switchInt: Int = 0
    
    var waterStationRepo: WaterStationDatabase = WaterStationDatabase()
    
    var newsItems: NSDictionary?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        waterFacts()
        loadFireBase()
        
       /* addNewStation(name: "School of Sustainability", desc: "1st Floor outside", rating: "3", long: "-111.935337", lat: "33.421484", url: "https://firebasestorage.googleapis.com/v0/b/sparky-2-0.appspot.com/o/wrigley-hall-building-with-turbines2.jpg?alt=media&token=195e3c99-c91d-489f-abdb-d88550d5a7b2")*/
        
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
    {}
    
    //Used to create an alert to the user
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in }))
        
        self.present(alert,animated: true, completion: nil)
    }
    
    //What happens when a row is selected in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchInt = indexPath.row
        performSegue(withIdentifier: "segueToDetailView", sender: self)
        
    }
    
    //Prepare to seague to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.station = waterStationRepo.waterStationArray[switchInt]
        
    }
    
    //This funciton handles the procedure of retrieivng information from dicitonary api
    //Also handles the updating of label that displays information and moves across screen
    func waterFacts()
    {
        //Initial values as app waits for api information
        var someArray = [String]()
        someArray.append("Water is good for you")
        someArray.append("Water is good for you")
        someArray.append("Water is good for you")
        someArray.append("Water is good for you")
        someArray.append("Water is good for you")
        
        //Get info using id and key
        let appId = "be4afe4d"
        let appKey = "813d79ea3016bf7c228fb6727eda1412"
        let language = "en"
        let word = "Water"
        let word_id = word.lowercased() //word id is case sensitive and lowercase is required
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        //Parse the information that is coming in
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response,
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject] {
                let data1 = jsonData["results"] as! NSMutableArray
                
                let data2 = data1.value(forKey: "lexicalEntries")
                var str = String(describing: data2)
                
                var upper:String.Index = String.Index(0)
                var lower:String.Index = String.Index(0)
                if let range = str.range(of: "hydroxyl ions") {
                    upper = range.upperBound
                    
                }
                else {
                    print("String not present1")
                }
                if let range = str.range(of: "\"Water is a compound") {
                    lower = range.lowerBound
                    
                }
                else {
                    print("String not present2")
                }
                let range = lower..<upper
                str = str.substring(with: range)
                
                someArray = str.components(separatedBy: NSCharacterSet(charactersIn: ":;") as CharacterSet)
            } else {
                print(error)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
        
        //This uses the array of facts to update a label as well as make the label move.
        //Moving is done async
        let startPlace = waterFactsLabel.center.x
        let queue = DispatchQueue.global()
        var move : CGFloat = 150
        var counter = 0;
        var firstTime = true
        var factCounter = 0
        queue.async {
            while(true)
            {
                counter = counter + 1;
                
                if(firstTime)
                {
                    firstTime = false;
                }
                else
                {
                    //Let label move
                    sleep(5)
                }
                DispatchQueue.main.sync {
                    
                    //Update label text and position
                    if(counter == 5)
                    {
                        counter = 0;
                        factCounter += 1
                        if(factCounter == 5)
                        {
                            factCounter = 0
                        }
                        self.waterFactsLabel.text = someArray[factCounter]
                        
                        self.waterFactsLabel.center.x = startPlace + 150
                    }
                    UIView.animate(withDuration: 8, animations: {
                        self.waterFactsLabel.center = CGPoint(x: self.waterFactsLabel.center.x - 150, y:self.waterFactsLabel.center.y)
                    })
                }
            }
        }
    }
    
    //This function adda a new water station to the firebase database. Only was used to initially fill the database.
    func addNewStation(name: String, desc: String, rating: String, long: String, lat: String, url: String)
    {
        refWater = Database.database().reference().child("stations");
        
        let key = refWater.childByAutoId().key
        
        //Create station to upload
         let station = ["stationKey": key,
         "stationName":name,
         "stationDesc": desc,
         "stationRating": rating,
         "stationLong": long,
         "stationLat" : lat,
         "stationPictureURL" : url
         ] as [String : Any]
        
        //Upload
         refWater.child(key).setValue(station)
        

    }
    
    //This function loads the firebase database into the app and reloads the tableview
    func loadFireBase()
    {
        refWater = Database.database().reference().child("stations");
        
        let key = refWater.childByAutoId().key
        
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
                    let stationURL = stationObject?["stationPictureURL"]
                    
                    //Create waterstaiton from info
                    let station = WaterStation(k: stationKey as! String, n: stationName as! String, d: stationDesc as! String, r: stationRating as! String, lon: stationLong as! String, lat: stationLat as! String, u: stationURL as! String)
                    
                    //appending it to list
                    self.waterStationRepo.addWaterStation(w: station)
                }
                
                //reloading the tableview
                self.stationTable.reloadData()
            }
        })
    }
}

