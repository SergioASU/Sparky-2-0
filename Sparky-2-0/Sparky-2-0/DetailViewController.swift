//
//  DetailViewController.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/26/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,CLLocationManagerDelegate
{
    var station : WaterStation = WaterStation()

    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionOfStation: UITextView!
    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var imageSource: UISegmentedControl!
    
    var manager = CLLocationManager()
    
    let picker = UIImagePickerController()
    
    let ratings = [0,1,2,3,4,5]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(ratings[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let ref = Database.database().reference().child("stations/" + self.station.key!)
        
        ref.updateChildValues([
            "stationRating": String(row)
            ])
        
        
    }
    //Set up all fields
    override func viewDidLoad()
    {
        manager = CLLocationManager()
        manager.delegate = self as! CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        picker.delegate = self // delegate added
        nameTextField.text = station.name
        descriptionOfStation.text = station.desc
        //self.picker.selectRow(Int(station.rating), inComponent: 0, animated: true)
        let url = URL(string: station.url!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.stationImage.image = UIImage(data: data!)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get new image from either photoviewr or camera
    @IBAction func newImage(_ sender: Any)
    {
        if imageSource.selectedSegmentIndex == 0
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                present(picker,animated: true,completion: nil)
            } else {
                print("No camera")
            }
            
        }else{
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            present(picker, animated: true, completion: nil)
        }

    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        self.stationImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //Button that when pressed saves the new image picked as the image for the station. Also updates the firebase data with the new url of the image
    @IBAction func savePressed(_ sender: Any)
    {
        let name = randomString(length: 5)
        let data = UIImagePNGRepresentation(stationImage.image!) as NSData?
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("images/" + name)
        
        
        let uploadTask = riversRef.putData(data as! Data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            let downloadURL = metadata.downloadURL()
            
            print("URL:\n")
            print(String(describing: downloadURL))
            
            let newURL = self.substring(string: String(describing: downloadURL), fromIndex: 9, toIndex: String(describing: downloadURL).characters.count-2)
            
            let ref = Database.database().reference().child("stations/" + self.station.key!)
            
            ref.updateChildValues([
                "stationPictureURL": newURL ?? "no url"
                ])
        
        }
        
    }
    
    //Used to create a new name for the new image
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //Used to get the substring of a string
    func substring(string: String, fromIndex: Int, toIndex: Int) -> String? {
        if fromIndex < toIndex && toIndex < string.characters.count /*use string.characters.count for swift3*/{
            let startIndex = string.index(string.startIndex, offsetBy: fromIndex)
            let endIndex = string.index(string.startIndex, offsetBy: toIndex)
            return String(string[startIndex..<endIndex])
        }else{
            return nil
        }
    }
    
    //Button to open maps
    @IBAction func getDirections(_ sender: Any)
    {
        openMapForPlace()
    }
    
    //Function that opens apple maps
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = Double(station.locationLat!)!
        let longitude: CLLocationDegrees = Double(station.locationLong!)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = station.name
        mapItem.openInMaps(launchOptions: options)
    }

}
